#!/usr/bin/env python3
"""
Write every form extract_help_from_docs.py would cut from the help files, with
its filter switched off, so that sclang (tests/judge.scd) can decide which of
them are SuperCollider.

    python3 candidates_from_docs.py [output-dir]    (default target/judge/candidates)

Each form is named and headed exactly as the extraction script would name and
head it in tests/sc_help/, so a candidate and the corpus file cut from the same
form have the same path under their directories.
"""

import shutil
import sys
from pathlib import Path

from extract_help_from_docs import CODE_PATTERN, HELP_DIR, extract_forms, sanitize_filename


def main():
    out_dir = Path(sys.argv[1] if len(sys.argv) > 1 else "target/judge/candidates")
    if out_dir.exists():
        shutil.rmtree(out_dir)

    count = 0
    for schelp in sorted(HELP_DIR.rglob("*.schelp")):
        rel_path = schelp.relative_to(HELP_DIR)
        base_name = sanitize_filename(schelp.stem)
        blocks = CODE_PATTERN.findall(schelp.read_text(errors="ignore"))
        for i, block in enumerate(blocks):
            code = block.strip()
            if not code:
                continue
            forms = extract_forms(code)
            for j, form in enumerate(forms):
                header = f"// Source: {rel_path} block {i}"
                if len(forms) == 1:
                    name = f"{base_name}_{i}.scd"
                else:
                    suffix = chr(ord("a") + j) if j < 26 else f"_{j}"
                    name = f"{base_name}_{i}{suffix}.scd"
                    header += f" (part {j+1}/{len(forms)})"
                out_file = out_dir / rel_path.parent / name
                out_file.parent.mkdir(parents=True, exist_ok=True)
                out_file.write_text(header + "\n" + form + "\n")
                count += 1

    print(f"{count} candidates in {out_dir}")


if __name__ == "__main__":
    main()
