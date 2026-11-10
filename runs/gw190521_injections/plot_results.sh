#!/usr/bin/env bash
# Generate and run pycbc_inference_plot_posterior scripts, one per run.
# Edit MODES below to choose which runs to plot. Each entry is either
#   220            the 220-only run (no ringdown__amp<lmn> parameter),
#                  read from qnm220-<w>wavelet/
#   <lmn>[_<lmn>]  one or more extra modes joined by "_", e.g. 330 or 330_210;
#                  plots ringdown__amp<lmn> for each, read from
#                  qnm220_<lmn>[_<lmn>]-<w>wavelet/
# Prefix either form with "d" (e.g. d220, d330, d330_210) to read from the
# qnmd220...-<w>wavelet/ directory instead. Those runs also plot
# ringdown__dbetarad and ringdown__dphisamp; runs without the "d" do not.
# The directories are expected next to this script.
#
# If INPUT_NAME is empty, the single *.hdf file in each directory is used;
# set INPUT_NAME to pick a specific file name.
#
# If expected_params.txt exists next to this script, its contents replace the
# default --expected-parameters section, and the (delta_tc + t_switch)/<x>
# expression in --parameters is taken from the matching line in that file.
#
# A directory with no .hdf file in it is skipped with a message.
#
# Edit WAVELETS below to choose the wavelet counts w (1 and/or 2); each one
# selects the -<w>wavelet directories for every entry in MODES.
#
# Usage: ./make_plot_script.sh [--skip-existing]
#   For each wavelet count w and mode, cds into its directory, writes
#   plot_<mode>.sh there and runs it; the plot wav<w>_<mode>.png is written
#   next to this script.
#
# Options:
#   -s, --skip-existing   skip a run whose wav<w>_<mode>.png already exists
#   -h, --help            show this help
set -euo pipefail

usage() { sed -n '/^# Usage:/,/^set -euo/p' "$0" | sed -e '$d' -e 's/^# \{0,1\}//'; }

SKIP_EXISTING=0
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--skip-existing) SKIP_EXISTING=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
    esac
    shift
done

MODES=(220 210 330 440 330_210 210_320)
WAVELETS=(1 2)    # wavelet counts to plot: 1, 2 or both, e.g. (1 2)
INPUT_NAME=""   # e.g. "result.hdf"; empty = auto-detect the one *.hdf file
EXPECTED_FILE=expected_params.txt

# Used when EXPECTED_FILE is missing. (A function rather than a heredoc inside
# $(...), which older bash versions such as macOS's bash 3.2 fail to parse.)
default_expected() {
    cat <<'EOF'
        --expected-parameters \
                'ringdown__final_mass:352.8710353022861' \
                'ringdown__final_spin:0.68646' \
                'ra:3.5' \
                'dec:0.73' \
                '(delta_tc + t_switch)/0.0017380630900662123:10' \
                'ringdown__inclination:0.5235987755982988' \
EOF
}

# Work from the directory containing this script, wherever it is run from.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

# Read the --expected-parameters section, cleaning it up so it can be pasted
# into the middle of the command: drop CRLF endings, trailing spaces and blank
# lines, and make sure every line ends with a continuation backslash.
load_expected() {
    local raw line out=""
    if [[ -f $EXPECTED_FILE ]]; then
        echo "Using expected parameters from $EXPECTED_FILE" >&2
        raw=$(sed -e 's/\r$//' -e 's/[[:space:]]*$//' -e '/^$/d' "$EXPECTED_FILE")
    else
        echo "No $EXPECTED_FILE found; using the default expected parameters" >&2
        raw=$(default_expected)
    fi
    if [[ $(head -n 1 <<< "$raw") != *--expected-parameters* ]]; then
        echo "Error: first line of $EXPECTED_FILE must contain --expected-parameters" >&2
        return 1
    fi
    while IFS= read -r line; do
        [[ $line == *\\ ]] || line="$line \\"
        out+="$line"$'\n'
    done <<< "$raw"
    printf '%s' "$out"
}

EXPECTED_BLOCK=$(load_expected)

# The time parameter: everything before the last colon on the
# (delta_tc + t_switch) line, e.g. (delta_tc + t_switch)/0.0017380630900662123
time_key() {
    printf '%s\n' "$EXPECTED_BLOCK" | grep -m 1 'delta_tc' \
        | sed -n "s/^[[:space:]]*'\(.*\):[^:]*'[[:space:]]*\\\\$/\1/p"
}
TIME_KEY=$(time_key || true)
if [[ -z $TIME_KEY ]]; then
    TIME_KEY='(delta_tc + t_switch)/0.0017380630900662123'
    echo "Warning: no (delta_tc + t_switch) line in the expected parameters;" \
         "using $TIME_KEY" >&2
fi
echo "Time parameter: $TIME_KEY" >&2
TIME_LINE="                '${TIME_KEY}:\$t_{ringdown}~(M_f^{inj})\$' \\"

# Print the input file for a directory. Returns 2 if the directory has no
# .hdf file at all (the caller skips it), 1 for any other problem.
find_input() {
    local dir=$1
    if [[ ! -d $dir ]]; then
        echo "Error: directory '$dir' not found" >&2
        return 1
    fi
    local files=("$dir"/*.hdf)
    if [[ ! -f ${files[0]} ]]; then
        return 2
    fi
    if [[ -n $INPUT_NAME ]]; then
        if [[ ! -f $dir/$INPUT_NAME ]]; then
            echo "Error: '$dir/$INPUT_NAME' not found" >&2
            return 1
        fi
        echo "$dir/$INPUT_NAME"
        return 0
    fi
    if [[ ${#files[@]} -gt 1 ]]; then
        echo "Error: several .hdf files in '$dir'; set INPUT_NAME:" >&2
        printf '  %s\n' "${files[@]}" >&2
        return 1
    fi
    echo "${files[0]}"
}

if [[ ${#WAVELETS[@]} -eq 0 ]]; then
    echo "Error: WAVELETS is empty" >&2
    exit 1
fi
for W in "${WAVELETS[@]}"; do
    if [[ $W != 1 && $W != 2 ]]; then
        echo "Error: WAVELETS entries must be 1 or 2 (got '$W')" >&2
        exit 1
    fi
done

# Every (wavelet count, mode) pair to plot, as "<w>:<mode>".
JOBS=()
for W in "${WAVELETS[@]}"; do
    for MODE in "${MODES[@]}"; do
        JOBS+=("$W:$MODE")
    done
done

SKIPPED=()
SKIPPED_EXISTING=()
for JOB in "${JOBS[@]}"; do
    W=${JOB%%:*}
    MODE=${JOB#*:}
    TAG=wav${W}_${MODE}   # names this run in messages and the plot file
    if [[ ! $MODE =~ ^d?[0-9]{3}(_[0-9]{3})*$ ]]; then
        echo "Error: '$MODE' is not [d]220 or a '_'-separated list of three-digit" \
             "lmn strings, optionally prefixed with d" >&2
        exit 1
    fi

    # A leading "d" selects the qnmd220... directories and the extra
    # dbetarad/dphisamp parameters.
    D=""
    BASE=$MODE
    if [[ $MODE == d* ]]; then
        D=d
        BASE=${MODE#d}
    fi

    if [[ $BASE == 220 ]]; then
        DIR=qnm${D}220-${W}wavelet
        AMPS=()
    else
        DIR=qnm${D}220_${BASE}-${W}wavelet
        IFS=_ read -r -a AMPS <<< "$BASE"
    fi

    PNG=${TAG}.png
    if [[ $SKIP_EXISTING -eq 1 && -f $PNG ]]; then
        echo "Skipping $TAG: $PNG already exists"
        SKIPPED_EXISTING+=("$TAG")
        continue
    fi

    RC=0
    INPUT=$(find_input "$DIR") || RC=$?
    if [[ $RC -eq 2 ]]; then
        echo "Skipping $TAG: no .hdf file in $DIR"
        SKIPPED+=("$TAG")
        continue
    elif [[ $RC -ne 0 ]]; then
        exit "$RC"
    fi
    INPUT=${INPUT##*/}   # file name only, since we run from inside $DIR
    OUT=plot_${MODE}.sh

    cd "$DIR"

    # The script is assembled from pieces: the header, one line per
    # ringdown__amp<lmn>, the time parameter, the remaining parameters (with
    # dbetarad/dphisamp only for "d" runs), the
    # expected-parameters section and the plot options. The quoted heredocs
    # are written verbatim; only @PNG@ is substituted.
    {
        sed "s/@PNG@/${PNG}/g" <<'EOF'
#!/usr/bin/env bash
FILENAME=$1
NAME=${FILENAME%%.*}

pycbc_inference_plot_posterior \
        --input-file $FILENAME \
        --output-file ../@PNG@ \
        --parameters \
                'ringdown__final_mass:$M_f$' \
                'ringdown__final_spin:$\chi_f$' \
EOF
        for LMN in ${AMPS[@]+"${AMPS[@]}"}; do
            printf "                'ringdown__amp%s:\$A_{%s}/A_{220}\$' \\\\\n" "$LMN" "$LMN"
        done
        printf '%s\n' "$TIME_LINE"
        cat <<'EOF'
                'ra:$\alpha$' \
                'dec:$\delta$' \
                'ringdown__amp220_snr:$\rho_{220}$' \
                'inspiral__amp1_snr:$\rho_1$' \
                'ringdown__inclination:$\iota$' \
EOF
        if [[ -n $D ]]; then
            cat <<'EOF'
                'ringdown__dbetarad * pi:$\Delta \beta$' \
                'ringdown__dphisamp - pi:$\Delta \phi$' \
EOF
        fi
        cat <<'EOF'
EOF
        printf '%s\n' "$EXPECTED_BLOCK"
        cat <<'EOF'
        --plot-scatter \
                --z-arg loglikelihood \
                --plot-maxl \
                --scatter-cmap viridis \
        --plot-marginal \
                --no-marginal-lines
EOF
    } > "$OUT"

    chmod +x "$OUT"
    echo "Wrote $DIR/$OUT"

    echo "Running $DIR/$OUT on $DIR/$INPUT ..."
    ./"$OUT" "$INPUT"
    echo "Finished $DIR/$OUT -> $PNG"

    cd "$SCRIPT_DIR"
done

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
    echo "Skipped (no .hdf file): ${SKIPPED[*]}"
fi
if [[ ${#SKIPPED_EXISTING[@]} -gt 0 ]]; then
    echo "Skipped (png already exists): ${SKIPPED_EXISTING[*]}"
fi

