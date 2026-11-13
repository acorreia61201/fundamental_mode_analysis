#!/usr/bin/env bash
# Collect the evidence comparison and the posterior plots into one Markdown file.
#
# Run this from the directory holding the wav<w>_*.png plots. It reads the
# saved output of compare_evidence.py, e.g.
#     ./compare_evidence.py > evidences.txt
# and writes:
#   0. the combined posterior plot, combined_common.png, under the title
#      "Combined posterior from all runs" (the link is written even if the
#      file isn't there yet, with a warning),
#   1. a table of every run's log evidence and its difference from the
#      matching 220-only run,
#   2. the 220-only reference evidences,
#   3. any runs compare_evidence.py skipped,
#   4. every wav<w>_*.png plot, for any wavelet count w, linked by its
#      absolute path, each under a title naming its modes (and the wavelet
#      count, if not 1), e.g.
#      wav1_221.png -> "220+221", wav1_d221.png -> "220+221, negative mode",
#      wav3_d221.png -> "220+221, negative mode, 3 wavelet".
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

# The wavelet counts that have plots here, in numerical order, taken from
# file names of the form wav<w>_<mode>.png.
wavelet_counts() {
    local f w
    for f in wav[0-9]*_*.png; do
        [[ -f $f ]] || continue
        w=${f#wav}
        w=${w%%_*}
        [[ $w =~ ^[0-9]+$ ]] && echo "$w"
    done | sort -n -u
    return 0
}

# Plot order: by wavelet count, smallest first. Within each, the 220-only
# plot first, then the other plots, for the runs without dbeta/dphi and then
# for the "d" runs.
ordered_plots() {
    local w prefix f
    for w in $(wavelet_counts); do
        for prefix in "wav${w}_" "wav${w}_d"; do
            [[ -f ${prefix}220.png ]] && echo "${prefix}220.png"
            for f in "$prefix"[0-9]*.png; do
                [[ -f $f && $f != "${prefix}220.png" ]] && echo "$f"
            done
        done
    done
    return 0
}

PLOT_DIR=$(pwd -P)   # absolute path of the directory holding the plots
COMBINED_PLOT=combined_common.png
COMBINED_TITLE="Combined posterior from all runs"
if [[ ! -f $COMBINED_PLOT ]]; then
    echo "Warning: $COMBINED_PLOT not found; leaving a link to it in the report" >&2
fi

# Markdown image line for a plot in PLOT_DIR. Link targets can't contain
# spaces unless wrapped in <...>.
image_line() {
    local title=$1 path=$PLOT_DIR/$2
    if [[ $path == *" "* ]]; then
        echo "![$title](<$path>)"
    else
        echo "![$title]($path)"
    fi
}

{
    echo "# Ringdown mode comparison"
    echo
    echo "## $COMBINED_TITLE"
    echo
    image_line "$COMBINED_TITLE" "$COMBINED_PLOT"
    echo
    echo "## Log evidence"
    echo
    echo "Δ ln Z is each run's log evidence minus that of the matching 220-only run"
    echo "(the natural-log Bayes factor against the 220-only model)."
    echo
    echo "| Modes | ln Z | Δ ln Z |"
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
            if [[ $kind == SKIP ]]; then
                echo "- $message"
            fi
        done <<< "$RECORDS"
    fi

    echo
    echo "## Posterior plots"
    PLOTS=$(ordered_plots)
    if [[ -z $PLOTS ]]; then
        echo
        echo "No wav<w>_*.png plots found."
    fi
    while IFS= read -r png; do
        [[ -n $png ]] || continue
        w=${png#wav}
        w=${w%%_*}
        mode=${png#wav*_}
        mode=${mode%.png}
        title=$(mode_title "$mode")
        if [[ $w != 1 ]]; then
            title="$title, $w wavelet"
        fi
        echo
        echo "### $title"
        echo
        image_line "$title" "$png"
    done <<< "$PLOTS"
} > "$OUTPUT_FILE"

echo "Wrote $OUTPUT_FILE"
