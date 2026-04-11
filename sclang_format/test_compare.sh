#!/bin/bash

for input_file in ./tests/fixtures/*/input.scd; do
    test_name=$(basename $(dirname "$input_file"))
    snap_file="./tests/snapshots/fixtures_insta__${test_name}__inline@out.snap"
    snap_new_file="./tests/snapshots/fixtures_insta__${test_name}__inline@out.snap.new"

    if [[ -f "$snap_file" ]] ; then
        echo "=== $test_name ==="
        sdiff -w 150 "$input_file" "$snap_file" | head -50
        echo ""
    fi
    if [[ -f "$snap_new_file" ]] ; then
        echo "=== $test_name ==="
        sdiff -w 150 "$input_file" "$snap_new_file" | head -50
        echo ""
    fi
done

for input_file in ./tests/sc_help/**/*.scd; do
    # sc_help/Classes/Foo_0.scd -> sc_help__Classes__Foo_0
    rel_path="${input_file#./tests/}"
    snap_name="${rel_path//\//__}"
    snap_name="${snap_name%.scd}"

    snap_file="./tests/snapshots/fixtures_insta__${snap_name}@out.snap"
    snap_new_file="${snap_file}.new"

    if [[ -f "$snap_file" ]]; then
        echo "=== $rel_path ==="
        sdiff -w 150 "$input_file" "$snap_file" | head -50
        echo ""
    fi
    if [[ -f "$snap_new_file" ]]; then
        echo "=== $rel_path (NEW) ==="
        sdiff -w 150 "$input_file" "$snap_new_file" | head -50
        echo ""
    fi
done
