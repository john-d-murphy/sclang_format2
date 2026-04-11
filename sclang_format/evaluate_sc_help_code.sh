#!/usr/bin/env bash
set -u
set -o pipefail

SHARD_DIR="target/sc_help_shards"

mkdir -p "$SHARD_DIR"
rm -f "$SHARD_DIR"/shard_*.tsv

# Run tests, but DON'T abort the script if they fail (cargo exits 101 on test failure)
echo "Running shard tests..."
time cargo test sc_help_corpus_shard_ -- --test-threads 16 2>&1 > /dev/null
TEST_RC=$?
echo "cargo test exit code: $TEST_RC"

# If no TSVs, bail with a clear message
if ! ls "$SHARD_DIR"/shard_*.tsv >/dev/null 2>&1; then
  echo "No shard TSVs found in $SHARD_DIR/ (did the tests write them?)"
  exit "$TEST_RC"
fi

# Collate SUMMARY rows
awk -F'\t' '
  $1=="SUMMARY" { succ+=$4; pf+=$5; idem+=$6; shards=$3 }
  END {
    total=succ+pf+idem;
    printf "=== SC Help Corpus (Collated) ===\n";
    printf "Total: %d\nSuccess: %d\nParse failures: %d\nIdempotency failures: %d\n",
           total, succ, pf, idem;
  }
' "$SHARD_DIR"/shard_*.tsv

# Parse-failure file list (field 3 = path)
grep -h '^PF' "$SHARD_DIR"/shard_*.tsv | cut -f3 | sort -u > /tmp/pf_files.txt

# 1) build membership lists (FAST: 3 rg runs total)
xargs -d '\n' -a /tmp/pf_files.txt rg -l -m1 \
  '^(link::|section::|subsection::|categories::|CLASS::|TITLE::|METHOD::|=+|---$)' \
  > /tmp/pf.NOT_CODE_SCDOC_MARKUP.list || true

xargs -d '\n' -a /tmp/pf_files.txt rg -l -m1 \
  '^\(setq|\(add-to-list|\(require\b' \
  > /tmp/pf.NOT_CODE_EDITOR_CONFIG.list || true

xargs -d '\n' -a /tmp/pf_files.txt rg -l -m1 \
  '^\s*[A-Z]\w*\s*:\s*\w+\s*\{' \
  > /tmp/pf.CLASSDEF_OR_CLASSLIB_SNIPPET.list || true

# 2) bucket everything in one awk pass (gawk: uses ARGIND)
gawk '
  ARGIND==1 {a[$0]=1; next}
  ARGIND==2 {b[$0]=1; next}
  ARGIND==3 {c[$0]=1; next}
  {
    f=$0; bucket="SC_GRAMMAR_GAP";
    if (a[f]) bucket="NOT_CODE_SCDOC_MARKUP";
    else if (b[f]) bucket="NOT_CODE_EDITOR_CONFIG";
    else if (c[f]) bucket="CLASSDEF_OR_CLASSLIB_SNIPPET";
    print bucket "\t" f
  }
' /tmp/pf.NOT_CODE_SCDOC_MARKUP.list \
  /tmp/pf.NOT_CODE_EDITOR_CONFIG.list \
  /tmp/pf.CLASSDEF_OR_CLASSLIB_SNIPPET.list \
  /tmp/pf_files.txt \
> /tmp/pf_bucketed.tsv

cut -f1 /tmp/pf_bucketed.tsv | sort | uniq -c | sort -nr

# file -> trigger mapping (dedup)
grep -h '^PF' "$SHARD_DIR"/shard_*.tsv \
| awk -F'\t' '{print $3 "\t" $5}' \
| sort -u > /tmp/pf_file_trigger.tsv

printf "=== Rule Failures (Collated) ===\n";
# Extract (file:method) pairs, then join to trigger, then count (trigger, method)
cat /tmp/pf_file_trigger.tsv | awk '{print $2}' | sort | uniq -c | sort -nr | head -120

# If the tests failed, propagate that failure code at the end (so CI still fails)
exit "$TEST_RC"

