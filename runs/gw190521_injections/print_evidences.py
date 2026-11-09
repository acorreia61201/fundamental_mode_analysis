#!/usr/bin/env python
"""Compare the log evidence of the qnm220* and qnmd220* ringdown runs.

Loops over every qnm220* and qnmd220* directory next to this script, reads
the log evidence (and its error) from the .hdf file in each one, and prints:

* the 220-only evidence from qnm220-1wavelet and qnmd220-1wavelet, and
* for every other directory, its evidence minus the matching 220-only
  evidence: qnmd220* directories are compared with qnmd220-1wavelet,
  qnm220* directories with qnm220-1wavelet.

The difference is the natural-log Bayes factor of that run against the
220-only run. Its error is the two evidence errors added in quadrature.

Directories without an .hdf file are skipped. If a directory has more than
one .hdf file, set INPUT_NAME below to choose which one to read.

Usage: ./compare_evidence.py
"""

import glob
import math
import os
import sys

from pycbc.inference.io import loadfile

INPUT_NAME = ""  # e.g. "result.hdf"; empty = use the one *.hdf file
BASELINES = {"qnm220": "qnm220-1wavelet", "qnmd220": "qnmd220-1wavelet"}


def find_input(dirname):
    """Return the .hdf file to read in ``dirname``, or None to skip it."""
    files = sorted(glob.glob(os.path.join(dirname, "*.hdf")))
    if not files:
        print(f"Skipping {dirname}: no .hdf file")
        return None
    if INPUT_NAME:
        path = os.path.join(dirname, INPUT_NAME)
        if not os.path.isfile(path):
            print(f"Skipping {dirname}: {INPUT_NAME} not found")
            return None
        return path
    if len(files) > 1:
        print(f"Skipping {dirname}: several .hdf files, set INPUT_NAME: "
              + ", ".join(os.path.basename(f) for f in files))
        return None
    return files[0]


def read_evidence(path):
    """Return (log evidence, error) from an inference file, or None."""
    try:
        with loadfile(path, "r") as fp:
            lnz, dlnz = fp.log_evidence
    except KeyError:
        print(f"Skipping {path}: no log_evidence stored in the file")
        return None
    return float(lnz), float(dlnz)


def family(dirname):
    """qnmd220 or qnm220, depending on how the directory name starts."""
    return "qnmd220" if dirname.startswith("qnmd220") else "qnm220"


def main():
    # Work from the directory containing this script.
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    dirs = sorted(d for d in glob.glob("qnm220*") + glob.glob("qnmd220*")
                  if os.path.isdir(d))
    if not dirs:
        sys.exit("No qnm220* or qnmd220* directories found")

    evidence = {}
    for d in dirs:
        path = find_input(d)
        if path is None:
            continue
        result = read_evidence(path)
        if result is not None:
            evidence[d] = result

    print()
    print("220-only log evidence")
    for fam in ("qnm220", "qnmd220"):
        base = BASELINES[fam]
        if base in evidence:
            lnz, dlnz = evidence[base]
            print(f"  {base:<30} ln Z = {lnz:.3f} +/- {dlnz:.3f}")
        else:
            print(f"  {base:<30} not available")

    print()
    print("Log evidence relative to the matching 220-only run")
    print(f"  {'directory':<30} {'ln Z':>22}   {'ln Z - ln Z_220':>22}"
          "   compared with")
    for d in dirs:
        if d in BASELINES.values() or d not in evidence:
            continue
        lnz, dlnz = evidence[d]
        base = BASELINES[family(d)]
        line = f"  {d:<30} {lnz:>12.3f} +/- {dlnz:<6.3f}"
        if base in evidence:
            base_lnz, base_dlnz = evidence[base]
            diff = lnz - base_lnz
            err = math.hypot(dlnz, base_dlnz)
            line += f"   {diff:>12.3f} +/- {err:<6.3f}   {base}"
        else:
            line += f"   {'n/a':>22}   {base} not available"
        print(line)


if __name__ == "__main__":
    main()

