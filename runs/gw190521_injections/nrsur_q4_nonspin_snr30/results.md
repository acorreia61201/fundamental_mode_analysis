# Ringdown mode comparison

## Combined posterior from all runs

![Combined posterior from all runs](combined_common.png)

## Log evidence

Δ ln Z is each run's log evidence minus that of the matching 220-only run
(the natural-log Bayes factor against the 220-only model).

| Modes | ln Z | Δ ln Z |
|---|---:|---:|
| [220+330+210, 3 wavelet](#wav3_330_210) | 6433403.591 ± 0.074 | 109.777 ± 0.095 |
| [220+330+210, 2 wavelet](#wav2_330_210) | 6433403.172 ± 0.076 | 109.358 ± 0.096 |
| [220+330, 2 wavelet](#wav2_330) | 6433401.590 ± 0.083 | 107.776 ± 0.102 |
| [220+210+320, negative mode, 2 wavelet](#wav2_d210_320) | 6433401.960 ± 0.053 | 107.719 ± 0.078 |
| [220+330, negative mode, 2 wavelet](#wav2_d330) | 6433401.422 ± 0.056 | 107.180 ± 0.080 |
| [220+330, negative mode, 3 wavelet](#wav3_d330) | 6433401.365 ± 0.074 | 107.124 ± 0.094 |
| [220+330+210, negative mode, 3 wavelet](#wav3_d330_210) | 6433401.286 ± 0.081 | 107.045 ± 0.099 |
| [220+330+210, negative mode, 2 wavelet](#wav2_d330_210) | 6433400.311 ± 0.063 | 106.069 ± 0.085 |
| [220+330, 3 wavelet](#wav3_330) | 6433399.397 ± 0.061 | 105.583 ± 0.085 |
| [220+210+320, negative mode, 3 wavelet](#wav3_d210_320) | 6433398.718 ± 0.093 | 104.477 ± 0.109 |
| [220+210+320, 3 wavelet](#wav3_210_320) | 6433397.492 ± 0.057 | 103.678 ± 0.083 |
| [220+210+320, 2 wavelet](#wav2_210_320) | 6433396.619 ± 0.082 | 102.805 ± 0.102 |
| [220+330+210](#wav1_330_210) | 6433389.084 ± 0.055 | 95.270 ± 0.081 |
| [220+330+210, negative mode](#wav1_d330_210) | 6433389.238 ± 0.058 | 94.997 ± 0.082 |
| [220+221, 3 wavelet](#wav3_221) | 6433382.252 ± 0.081 | 88.438 ± 0.100 |
| [220+210+320, negative mode](#wav1_d210_320) | 6433382.300 ± 0.071 | 88.058 ± 0.091 |
| [220+221, negative mode, 3 wavelet](#wav3_d221) | 6433381.082 ± 0.084 | 86.840 ± 0.102 |
| [220+221, negative mode, 2 wavelet](#wav2_d221) | 6433380.214 ± 0.074 | 85.973 ± 0.094 |
| [220+210+320](#wav1_210_320) | 6433377.321 ± 0.051 | 83.507 ± 0.078 |
| [220+221, 2 wavelet](#wav2_221) | 6433376.365 ± 0.071 | 82.551 ± 0.093 |
| [220, negative mode, 3 wavelet](#wav3_d220) | 6433374.855 ± 0.090 | 80.614 ± 0.106 |
| [220+210, negative mode, 2 wavelet](#wav2_d210) | 6433370.696 ± 0.072 | 76.454 ± 0.092 |
| [220+210, negative mode, 3 wavelet](#wav3_d210) | 6433369.615 ± 0.085 | 75.374 ± 0.103 |
| [220, 3 wavelet](#wav3_220) | 6433368.455 ± 0.085 | 74.641 ± 0.104 |
| [220+330](#wav1_330) | 6433366.526 ± 0.055 | 72.712 ± 0.081 |
| [220+330, negative mode](#wav1_d330) | 6433366.386 ± 0.053 | 72.144 ± 0.078 |
| [220+210, 2 wavelet](#wav2_210) | 6433364.804 ± 0.074 | 70.990 ± 0.095 |
| [220+440, 3 wavelet](#wav3_440) | 6433363.332 ± 0.069 | 69.518 ± 0.091 |
| [220+210, 3 wavelet](#wav3_210) | 6433362.145 ± 0.064 | 68.331 ± 0.087 |
| [220+440, negative mode, 3 wavelet](#wav3_d440) | 6433361.332 ± 0.075 | 67.090 ± 0.094 |
| [220+440, 2 wavelet](#wav2_440) | 6433360.889 ± 0.072 | 67.075 ± 0.093 |
| [220+440, negative mode, 2 wavelet](#wav2_d440) | 6433361.302 ± 0.070 | 67.061 ± 0.091 |
| [220, negative mode, 2 wavelet](#wav2_d220) | 6433353.647 ± 0.081 | 59.405 ± 0.099 |
| [220, 2 wavelet](#wav2_220) | 6433350.413 ± 0.092 | 56.599 ± 0.110 |
| [220+210, negative mode](#wav1_d210) | 6433333.446 ± 0.062 | 39.204 ± 0.084 |
| [220+210](#wav1_210) | 6433330.698 ± 0.071 | 36.884 ± 0.093 |
| [220+440](#wav1_440) | 6433330.275 ± 0.048 | 36.461 ± 0.077 |
| [220+440, negative mode](#wav1_d440) | 6433330.517 ± 0.087 | 36.276 ± 0.104 |
| [220+221](#wav1_221) | 6433317.978 ± 0.078 | 24.164 ± 0.098 |
| [220+221, negative mode](#wav1_d221) | 6433313.380 ± 0.015 | 19.138 ± 0.059 |

### 220-only reference evidence

| Modes | ln Z |
|---|---:|
| [220](#wav1_220) | 6433293.814 ± 0.059 |
| [220, negative mode](#wav1_d220) | 6433294.242 ± 0.057 |

## Posterior plots

<a id="wav3_330_210"></a>

### 220+330+210, 3 wavelet

![220+330+210, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_330_210.png)

<a id="wav2_330_210"></a>

### 220+330+210, 2 wavelet

![220+330+210, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_330_210.png)

<a id="wav2_330"></a>

### 220+330, 2 wavelet

![220+330, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_330.png)

<a id="wav2_d210_320"></a>

### 220+210+320, negative mode, 2 wavelet

![220+210+320, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d210_320.png)

<a id="wav2_d330"></a>

### 220+330, negative mode, 2 wavelet

![220+330, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d330.png)

<a id="wav3_d330"></a>

### 220+330, negative mode, 3 wavelet

![220+330, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d330.png)

<a id="wav3_d330_210"></a>

### 220+330+210, negative mode, 3 wavelet

![220+330+210, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d330_210.png)

<a id="wav2_d330_210"></a>

### 220+330+210, negative mode, 2 wavelet

![220+330+210, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d330_210.png)

<a id="wav3_330"></a>

### 220+330, 3 wavelet

![220+330, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_330.png)

<a id="wav3_d210_320"></a>

### 220+210+320, negative mode, 3 wavelet

![220+210+320, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d210_320.png)

<a id="wav3_210_320"></a>

### 220+210+320, 3 wavelet

![220+210+320, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_210_320.png)

<a id="wav2_210_320"></a>

### 220+210+320, 2 wavelet

![220+210+320, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_210_320.png)

<a id="wav1_330_210"></a>

### 220+330+210

![220+330+210](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_330_210.png)

<a id="wav1_d330_210"></a>

### 220+330+210, negative mode

![220+330+210, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d330_210.png)

<a id="wav3_221"></a>

### 220+221, 3 wavelet

![220+221, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_221.png)

<a id="wav1_d210_320"></a>

### 220+210+320, negative mode

![220+210+320, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d210_320.png)

<a id="wav3_d221"></a>

### 220+221, negative mode, 3 wavelet

![220+221, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d221.png)

<a id="wav2_d221"></a>

### 220+221, negative mode, 2 wavelet

![220+221, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d221.png)

<a id="wav1_210_320"></a>

### 220+210+320

![220+210+320](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_210_320.png)

<a id="wav2_221"></a>

### 220+221, 2 wavelet

![220+221, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_221.png)

<a id="wav3_d220"></a>

### 220, negative mode, 3 wavelet

![220, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d220.png)

<a id="wav2_d210"></a>

### 220+210, negative mode, 2 wavelet

![220+210, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d210.png)

<a id="wav3_d210"></a>

### 220+210, negative mode, 3 wavelet

![220+210, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d210.png)

<a id="wav3_220"></a>

### 220, 3 wavelet

![220, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_220.png)

<a id="wav1_330"></a>

### 220+330

![220+330](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_330.png)

<a id="wav1_d330"></a>

### 220+330, negative mode

![220+330, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d330.png)

<a id="wav2_210"></a>

### 220+210, 2 wavelet

![220+210, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_210.png)

<a id="wav3_440"></a>

### 220+440, 3 wavelet

![220+440, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_440.png)

<a id="wav3_210"></a>

### 220+210, 3 wavelet

![220+210, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_210.png)

<a id="wav3_d440"></a>

### 220+440, negative mode, 3 wavelet

![220+440, negative mode, 3 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav3_d440.png)

<a id="wav2_440"></a>

### 220+440, 2 wavelet

![220+440, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_440.png)

<a id="wav2_d440"></a>

### 220+440, negative mode, 2 wavelet

![220+440, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d440.png)

<a id="wav2_d220"></a>

### 220, negative mode, 2 wavelet

![220, negative mode, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_d220.png)

<a id="wav2_220"></a>

### 220, 2 wavelet

![220, 2 wavelet](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav2_220.png)

<a id="wav1_d210"></a>

### 220+210, negative mode

![220+210, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d210.png)

<a id="wav1_210"></a>

### 220+210

![220+210](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_210.png)

<a id="wav1_440"></a>

### 220+440

![220+440](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_440.png)

<a id="wav1_d440"></a>

### 220+440, negative mode

![220+440, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d440.png)

<a id="wav1_221"></a>

### 220+221

![220+221](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_221.png)

<a id="wav1_d221"></a>

### 220+221, negative mode

![220+221, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d221.png)

<a id="wav1_220"></a>

### 220

![220](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_220.png)

<a id="wav1_d220"></a>

### 220, negative mode

![220, negative mode](/home/alcorrei/bh_spec/fundamental_mode_analysis/runs/gw190521_injections/nrsur_q4_nonspin_snr30/wav1_d220.png)
