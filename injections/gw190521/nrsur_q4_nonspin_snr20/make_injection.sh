#!/usr/bin/env bash
set -e
eval "$(~/miniforge3/bin/conda shell.bash hook)" && conda activate fundamental_fork
export LAL_DATA_PATH=/home/alcorrei/opt/lalsuite-waveform-data
cd "$(dirname "$0")"
pycbc_create_injections --verbose --config-files injection.ini --output-file injection.hdf --variable-params-section variable_params \
			--static-params-section static_params --ninjections 1 --force
