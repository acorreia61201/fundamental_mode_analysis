# Searching for fundamental ringdown modes in GWs

Workspace for analyzing the ringdowns of GW190521, GW231123, and injections with significant fundamental mode contributions

## File structure

The `configs` top-level directory contains the configuration files for each run. 
Settings common to each run are stored in `common.ini`.
Each QNM configuration has its own file titled `lmn{qnm}.ini`.
Each waveform has its own file titled `data_{event}.ini` (or `data_{injection}.ini` for injection runs).
Each number of wavelets has its own file titled `wav{n}.ini`.

Each event/injection has its own correspondingly named top-level directory. 
Each directory will have its own `create_dirs` file that, when run, will generate one subdirectory per QNM configuration.
A Slurm script will be generated in each QNM directory for each wavelet configuration that contains the relevant `pycbc_inference` command. 
The Slurm script can be launched from the QNM directories to generate the HDF outputs.

There will also be a directory (either titled `frames` or `inj`) in each top-level directory that contains scripts to generate the reference waveform for each run.
(TODO: need to add configs and generation scripts for real noise injections)
