#!/usr/bin/env bash
# Collect the evidence comparison and the posterior plots into one Markdown file.
#
# Usage: ./make_report.sh [evidence_file] [output_file]
#   evidence_file  default: evidences.txt
#   output_file    default: results.md
set -euo pipefail

EVIDENCE_FILE=${1:-evidences.txt}
OUTPUT_FILE=${2:-results.md}

if [[ ! -f $EVIDENCE_FILE ]]; then
    echo "Error: evidence file '$EVIDENCE_FILE' not found" >&2
    exit 1
fi

# Turn a mode string into a title: 220 -> "220", 330_210 -> "220+330+210",
# and a leading "d" (dbeta/dphi runs) adds ", negative mode".
mode_title() {
    local mode=$1 suffix="" title
    if [[ $mode == d* ]]; then
        suffix=", negative mode"
        mode=${mode#d}
    fi
    if [[ $mode == 220 ]]; then
        title=220
    else
        title="220+${mode//_/+}"
    fi
    printf '%s%s' "$title" "$suffix"
}

# Directory name -> mode string, e.g. qnmd220_330-1wavelet -> d330,
# qnm220-1wavelet -> 220. Any -<n>wavelet ending is ignored here.
dir_mode() {
    local dir=${1%-*wavelet} d=""
    if [[ $dir == qnmd220* ]]; then
        d=d
        dir=${dir#qnmd220}
    else
        dir=${dir#qnm220}
    fi
    if [[ -z $dir ]]; then
        printf '%s220' "$d"
    else
        printf '%s%s' "$d" "${dir#_}"
    fi
}

# Table title for a run directory: the mode title, plus ", <n> wavelet" when
# the directory ends in -<n>wavelet with n other than 1,
# e.g. qnm220_330-2wavelet -> "220+330, 2 wavelet".
dir_title() {
    local dir=$1 n=""
    if [[ $dir == *-*wavelet ]]; then
        n=${dir##*-}
        n=${n%wavelet}
    fi
    mode_title "$(dir_mode "$dir")"
    if [[ -n $n && $n != 1 ]]; then
        printf ', %s wavelet' "$n"
    fi
}

# Pull the pieces out of compare_evidence.py's output as tab-separated records:
#   REF   <dir> <value>
#   ROW   <dir> <ln Z> <diff> <reference dir>
#   SKIP  <message>
parse_evidence() {
    sed 's/\r$//' "$EVIDENCE_FILE" | awk '
        BEGIN { OFS = "\t" }
        /^Skipping / { sub(/^Skipping /, ""); print "SKIP", $0; next }
        /^220-only log evidence/ { section = "ref"; next }
        /^Log evidence relative/ { section = "rows"; next }
        NF == 0 { next }
        section == "ref" {
            if ($0 ~ /not available/) print "REF", $1, "not available"
            else print "REF", $1, $5 " ± " $7
            next
        }
        section == "rows" {
            if ($1 == "directory") next
            lnz = $2 " ± " $4
            if ($5 == "n/a") print "ROW", $1, lnz, "n/a", $6 " (not available)"
            else print "ROW", $1, lnz, $5 " ± " $7, $8
        }
    '
}

RECORDS=$(parse_evidence)
if ! grep -q '^ROW' <<< "$RECORDS" && ! grep -q '^REF' <<< "$RECORDS"; then
    echo "Error: no evidence results found in '$EVIDENCE_FILE'" \
         "(is it the output of compare_evidence.py?)" >&2
    exit 1
fi

# Plot order: the 220-only plot first, then the other plots, for the runs
# without dbeta/dphi and then for the "d" runs.
ordered_plots() {
    local prefix f
    for prefix in wav1_ wav1_d; do
        [[ -f ${prefix}220.png ]] && echo "${prefix}220.png"
        for f in "$prefix"[0-9]*.png; do
            [[ -f $f && $f != "${prefix}220.png" ]] && echo "$f"
        done
    done
    return 0
}

{
    echo "# Ringdown mode comparison"
    echo
    echo "## Log evidence"
    echo
    echo "ln B is each run's Bayes factor against the 220-only 1-wavelet run."
    echo "Runs with/out symmetry breaking are compared to the corresponding reference with/out the same parameters."
    echo "The raw evidences for the 220-only references are printed below."
    echo
    echo "| Modes | ln Z | ln B |"
    echo "|---|---:|---:|"
    while IFS=$'\t' read -r kind dir lnz diff base; do
        [[ $kind == ROW ]] || continue
        printf '| %s | %s | %s |\n' "$(dir_title "$dir")" "$lnz" "$diff"
    done <<< "$RECORDS"
    echo
    echo "### 220-only reference evidence"
    echo
    echo "| Modes | ln Z |"
    echo "|---|---:|"
    while IFS=$'\t' read -r kind dir value; do
        [[ $kind == REF ]] || continue
        printf '| %s | %s |\n' "$(dir_title "$dir")" "$value"
    done <<< "$RECORDS"

    if grep -q '^SKIP' <<< "$RECORDS"; then
        echo
        echo "### Skipped runs"
        echo
        while IFS=$'\t' read -r kind message; do
            [[ $kind == SKIP ]] && echo "- $message"
        done <<< "$RECORDS"
    fi

    echo
    echo "## Posterior plots"
    PLOTS=$(ordered_plots)
    PLOT_DIR=$(pwd -P)   # absolute path of the directory holding the plots
    if [[ -z $PLOTS ]]; then
        echo
        echo "No wav1_*.png plots found."
    fi
    while IFS= read -r png; do
        [[ -n $png ]] || continue
        mode=${png#wav1_}
        mode=${mode%.png}
        title=$(mode_title "$mode")
        echo
        echo "### $title"
        echo
        path=$PLOT_DIR/$png
        # Markdown link targets can't contain spaces unless wrapped in <...>.
        if [[ $path == *" "* ]]; then
            echo "![$title](<$path>)"
        else
            echo "![$title]($path)"
        fi
    done <<< "$PLOTS"
} > "$OUTPUT_FILE"

echo "Wrote $OUTPUT_FILE"
