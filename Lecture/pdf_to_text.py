"""
Convert lecture PDFs to text files using pdftotext.

- Root-level: ALL PDFs are converted (lecture slides, review, reference)
- Subdirectories: ONLY LxxExercises.pdf files are converted
- Output: extracted_text/ preserving the original folder structure

Requires: pdftotext (from poppler/xpdf) on your PATH
"""

import re
import subprocess
import sys
from pathlib import Path


def main():
    script_dir = Path(__file__).resolve().parent
    output_root = script_dir / "extracted_text"

    # Collect all PDFs recursively
    all_pdfs = sorted(script_dir.rglob("*.pdf"))

    # Filter: root-level → all; subdirectories → only LxxExercises.pdf
    pdfs_to_convert = []
    skipped = []
    exercise_pattern = re.compile(r"L\d{2}Exercises\.pdf")

    for pdf in all_pdfs:
        if pdf.parent == script_dir:
            # Root-level: convert all PDFs
            pdfs_to_convert.append(pdf)
        elif exercise_pattern.match(pdf.name):
            # Subdirectory: only LxxExercises.pdf
            pdfs_to_convert.append(pdf)
        else:
            skipped.append(pdf)

    if not pdfs_to_convert:
        print("No matching PDF files found.")
        return

    print(f"Found {len(pdfs_to_convert)} PDF(s) to convert")
    if skipped:
        print(f"Skipping {len(skipped)} PDF(s) (non-exercise files in subdirectories)\n")
    else:
        print()

    success = 0
    failed = 0

    for pdf in pdfs_to_convert:
        # Determine output path, mirroring the relative structure
        rel_path = pdf.relative_to(script_dir)
        txt_path = output_root / rel_path.with_suffix(".txt")
        txt_path.parent.mkdir(parents=True, exist_ok=True)

        try:
            result = subprocess.run(
                ["pdftotext", str(pdf), str(txt_path)],
                capture_output=True,
                text=True,
                timeout=60,
            )
            if result.returncode == 0:
                print(f"  OK  {rel_path}")
                success += 1
            else:
                print(f"  FAIL  {rel_path}: {result.stderr.strip()}")
                failed += 1
        except subprocess.TimeoutExpired:
            print(f"  FAIL  {rel_path}: timed out")
            failed += 1
        except FileNotFoundError:
            print(
                "Error: pdftotext not found. Make sure it is installed and on your PATH."
            )
            sys.exit(1)
        except Exception as e:
            print(f"  FAIL  {rel_path}: {e}")
            failed += 1

    print(f"\nDone: {success} converted, {failed} failed")
    if success > 0:
        print(f"Output: {output_root}")


if __name__ == "__main__":
    main()
