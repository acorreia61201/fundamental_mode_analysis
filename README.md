# Searching for fundamental ringdown modes in GWs

Workspace for analyzing the ringdowns of GW190521, GW231123, and injections with significant fundamental mode contributions

## Requirements

You will need PyCBC version 2.9.0 (installable via `pip` as of August 7 2025). Additionally, you will need the wavelet waveform plugin: https://github.com/acorreia61201/wavelet_merger_model.

## File structure

The `configs` top-level directory contains the configuration files for each run. 
Settings common to each run are stored in `prior_common.ini`.
Each QNM configuration has its own file titled `prior_ringdown_{qnm}.ini`. QNM models with equatorial asymmetry allowed are denoted `prior_ringdown_d{qnm}.ini`.
Each waveform has its own file titled `data-{event}.ini` (or `data-{injection}.ini` for injection runs).
Each number of wavelets has its own file titled `prior_inspiral_{n}wavelet.ini`.
Sampler settings are stored in `sampler.ini`.
Model settings are stored in `model.ini`. Options specific to gating are stored in `gate_fixed_edge_*.ini`.
The executable `check_configs.py` makes sure that the composite config files to be run from the `runs` directory contain all the proper parameters.

The `injections` top-level directory contains the injection files for zero-noise simulated runs.
Currently only contains `gw190521` for GW190521-like zero-noise injections. Each injection models a 250M source-frame binary, with distances, mass ratios, and spins manipulated to match different GW190521 hypotheses.

The `psds` top-level directory contains PSDs extracted from the real data of GW190521, and is used to estimate the PSDs for zero-noise simulations.

The `runs` top-level directory contains results. Locally, this should also be the place where analyses are run and stored.
Injection results are stored in `gw190521_injections`.

Each injection's run results can be found at the following:

[q = 1, nonspinning, snr = 15](https://github.com/acorreia61201/fundamental_mode_analysis/blob/main/runs/gw190521_injections/nrsur_q1_nonspin_snr20/results.md)

[q = 4, nonspinning, snr = 15](https://github.com/acorreia61201/fundamental_mode_analysis/blob/main/runs/gw190521_injections/nrsur_q4_nonspin_snr20/results.md)

[q = 4, nonspinning, snr = 30](https://github.com/acorreia61201/fundamental_mode_analysis/blob/main/runs/gw190521_injections/nrsur_q4_nonspin_snr30/results.md)

[q = 8, nonspinning, snr = 15](https://github.com/acorreia61201/fundamental_mode_analysis/blob/main/runs/gw190521_injections/seobnr_q8_nonspin_snr20/results.md) (in progress)

[q = 4, precessing, snr = 15](https://github.com/acorreia61201/fundamental_mode_analysis/blob/main/runs/gw190521_injections/sxs_q1_prec_snr20/results.md) (in progress)
