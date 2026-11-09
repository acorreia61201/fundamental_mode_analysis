# Configuration files

The configuration of the hierarchical inspiral (wavelet) + ringdown (QNM) analyses, split into pieces that are
combined for each run. `pycbc_inference` takes several config files (`--config-files a.ini b.ini ...`). They are
combined by `WorkflowConfigParser`, so a section can be split across files, as long as no two files set the same
option in the same section.

| file | contents |
|---|---|
| `model.ini` | `[model]`, and the options of `[inspiral__model]` and `[ringdown__model]` that don't depend on the wavelets or modes |
| `sampler.ini` | `[sampler]` (dynesty, rslice, 16000 live points) |
| `data.ini` | the GW190521 data (trigger time, PSDs, inverse PSD length, segment, conditioning), as one `[inspiral__data&ringdown__data]` section that the parser copies into both data sections |
| `data-gw190521_nrsur_q4_nonspin_snr20.ini` | the injection file of the `nrsur_q4_nonspin_snr20` injection; used with `data.ini` |
| `gate_fixed_edge_1s.ini` | the gates: split at tc + t_switch, with the outer edges fixed at the trigger time ± 1.2 s in each detector |
| `gate_fixed_edge_invpsd.ini` | the same, with the outer edges at ± (inverse PSD length + 0.2 s), e.g. 8.2 s for an 8 s inverse PSD; the analysis segment must then be longer than in `data.ini` (e.g. -6 to 6 s) |
| `prior_common.ini` | the shared parameters: `delta_tc` (±100 ms), `t_switch` ([-50, 50) ms), the sky location, and tc |
| `prior_ringdown_220_330.ini` | the ringdown with the 220 and 330 modes, including the mode-dependent `[ringdown__model]` options |
| `prior_inspiral_{1,2,3}wavelet.ini` | the inspiral with 1, 2, or 3 wavelets, including the wavelet-dependent `[inspiral__model]` options |

The trigger time is set once, in `data.ini`. The other files refer to it (and to the inverse PSD length) as
`${inspiral__data|trigger-time}` (`${inspiral__data|psd-inverse-length}`).

**Paths:** the file paths in `data.ini` and the `data-*.ini` files are relative to the run directory, which is where
`pycbc_inference` runs. Run directories are always four levels below `run_files`
(`runs/<event>_injections/<injection>/<model>/`), so the paths start with `../../../../`.

**What the files encode:**
- **Inspiral:** the agnostic wavelet polarization prior, with each wavelet's own ε in [-1, 1] and θ in [0, π), and
  the inspiral polarization fixed to 0. The highest-frequency wavelet is the reference, centred at tc. The other
  wavelets' offsets are in [-100, 100) ms.
- **Ringdown:** the polarization is marginalized over [0, π).
- **SNRs:** the BayesWave signal prior (ρ* = 5) on [0, 50] for every wavelet and the 220 mode.

The 1- and 2-wavelet files reproduce the `qnm220_330-1wavelet` and `qnm220_330-2wavelet` runs in
`runs/gw190521_injections/nrsur_q4_nonspin_snr20/`.

The submit scripts made by `../make_runs.py` list the files to use. To change one piece, swap its file:
- a different number of wavelets: `prior_inspiral_<n>wavelet.ini`;
- a different injection: `data-<event>_<injection>.ini`;
- different ringdown modes: `prior_ringdown_<modes>.ini`;
- a different gate: `gate_*.ini`.

`check_configs.py` checks that, for each run under `../runs` with an `INFERENCE.hdf`, the config files listed in its
`submit.sh` combine to the configuration stored in `INFERENCE.hdf`, option by option. Paths are compared by file
name. It also checks the edges of `gate_fixed_edge_invpsd.ini`. Run it with `python check_configs.py`.
