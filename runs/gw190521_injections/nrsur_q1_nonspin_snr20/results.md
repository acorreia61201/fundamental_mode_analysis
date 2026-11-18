# Ringdown mode comparison

## Combined posterior from all runs

![Combined posterior from all runs](combined_common.png)

## Log evidence

Δ ln Z is each run's log evidence minus that of the matching 220-only run
(the natural-log Bayes factor against the 220-only model).

| Modes | ln Z | Δ ln Z |
|---|---:|---:|
| [220+210, negative mode](#wav1_d210) | 6433475.511 ± 0.059 | 0.061 ± 0.062 |
| [220+210](#wav1_210) | 6433475.459 ± 0.066 | -0.089 ± 0.087 |
| [220+221, negative mode](#wav1_d221) | 6433475.058 ± 0.051 | -0.393 ± 0.055 |
| [220+210+320, negative mode](#wav1_d210_320) | 6433474.404 ± 0.034 | -1.047 ± 0.039 |
| [220+210+320](#wav1_210_320) | 6433474.235 ± 0.034 | -1.314 ± 0.065 |
| [220+221](#wav1_221) | 6433474.210 ± 0.060 | -1.339 ± 0.082 |
| [220+440](#wav1_440) | 6433474.116 ± 0.032 | -1.432 ± 0.064 |
| [220+440, negative mode](#wav1_d440) | 6433473.970 ± 0.040 | -1.481 ± 0.045 |
| [220+330+210, negative mode](#wav1_d330_210) | 6433473.653 ± 0.057 | -1.797 ± 0.060 |
| [220+330, negative mode](#wav1_d330) | 6433473.424 ± 0.063 | -2.027 ± 0.066 |
| [220+330](#wav1_330) | 6433473.452 ± 0.024 | -2.096 ± 0.061 |
| [220+330+210](#wav1_330_210) | 6433473.207 ± 0.046 | -2.341 ± 0.072 |
| [220, negative mode, 2 wavelet](#wav2_d220) | 6433473.064 ± 0.063 | -2.387 ± 0.066 |
| [220+210, negative mode, 2 wavelet](#wav2_d210) | 6433472.858 ± 0.067 | -2.593 ± 0.070 |
| [220, 2 wavelet](#wav2_220) | 6433472.935 ± 0.038 | -2.613 ± 0.068 |
| [220+210, 2 wavelet](#wav2_210) | 6433472.711 ± 0.067 | -2.838 ± 0.087 |
| [220+221, negative mode, 2 wavelet](#wav2_d221) | 6433472.233 ± 0.012 | -3.218 ± 0.023 |
| [220+210+320, negative mode, 2 wavelet](#wav2_d210_320) | 6433471.690 ± 0.069 | -3.760 ± 0.071 |
| [220+440, negative mode, 2 wavelet](#wav2_d440) | 6433471.537 ± 0.049 | -3.914 ± 0.053 |
| [220+221, 2 wavelet](#wav2_221) | 6433471.510 ± 0.055 | -4.039 ± 0.078 |
| [220+210+320, 2 wavelet](#wav2_210_320) | 6433471.440 ± 0.063 | -4.108 ± 0.085 |
| [220+440, 2 wavelet](#wav2_440) | 6433471.388 ± 0.050 | -4.160 ± 0.075 |
| [220+330+210, 2 wavelet](#wav2_330_210) | 6433471.276 ± 0.037 | -4.272 ± 0.067 |
| [220+330+210, negative mode, 2 wavelet](#wav2_d330_210) | 6433471.078 ± 0.065 | -4.373 ± 0.068 |
| [220+330, negative mode, 2 wavelet](#wav2_d330) | 6433470.487 ± 0.020 | -4.964 ± 0.028 |
| [220+330, 2 wavelet](#wav2_330) | 6433470.529 ± 0.062 | -5.019 ± 0.083 |
| [220+210+320, 3 wavelet](#wav3_210_320) | 6433468.661 ± 0.051 | -6.887 ± 0.076 |

### 220-only reference evidence

| Modes | ln Z |
|---|---:|
| [220](#wav1_220) | 6433475.548 ± 0.056 |
| [220, negative mode](#wav1_d220) | 6433475.451 ± 0.019 |

### Skipped runs

- qnm220-3wavelet: no .hdf file
- qnm220_210-3wavelet: no .hdf file
- qnm220_221-3wavelet: no .hdf file
- qnm220_330-3wavelet: no .hdf file
- qnm220_330_210-3wavelet: no .hdf file
- qnm220_440-3wavelet: no .hdf file
- qnmd220-3wavelet: no .hdf file
- qnmd220_210-3wavelet: no .hdf file
- qnmd220_210_320-3wavelet: no .hdf file
- qnmd220_221-3wavelet: no .hdf file
- qnmd220_330-3wavelet: no .hdf file
- qnmd220_330_210-3wavelet: no .hdf file
- qnmd220_440-3wavelet: no .hdf file

## Posterior plots

<a id="wav1_d210"></a>

### 220+210, negative mode

![220+210, negative mode](wav1_d210.png)

<a id="wav1_220"></a>

### 220

![220](wav1_220.png)

<a id="wav1_d220"></a>

### 220, negative mode

![220, negative mode](wav1_d220.png)

<a id="wav1_210"></a>

### 220+210

![220+210](wav1_210.png)

<a id="wav1_d221"></a>

### 220+221, negative mode

![220+221, negative mode](wav1_d221.png)

<a id="wav1_d210_320"></a>

### 220+210+320, negative mode

![220+210+320, negative mode](wav1_d210_320.png)

<a id="wav1_210_320"></a>

### 220+210+320

![220+210+320](wav1_210_320.png)

<a id="wav1_221"></a>

### 220+221

![220+221](wav1_221.png)

<a id="wav1_440"></a>

### 220+440

![220+440](wav1_440.png)

<a id="wav1_d440"></a>

### 220+440, negative mode

![220+440, negative mode](wav1_d440.png)

<a id="wav1_d330_210"></a>

### 220+330+210, negative mode

![220+330+210, negative mode](wav1_d330_210.png)

<a id="wav1_d330"></a>

### 220+330, negative mode

![220+330, negative mode](wav1_d330.png)

<a id="wav1_330"></a>

### 220+330

![220+330](wav1_330.png)

<a id="wav1_330_210"></a>

### 220+330+210

![220+330+210](wav1_330_210.png)

<a id="wav2_d220"></a>

### 220, negative mode, 2 wavelet

![220, negative mode, 2 wavelet](wav2_d220.png)

<a id="wav2_d210"></a>

### 220+210, negative mode, 2 wavelet

![220+210, negative mode, 2 wavelet](wav2_d210.png)

<a id="wav2_220"></a>

### 220, 2 wavelet

![220, 2 wavelet](wav2_220.png)

<a id="wav2_210"></a>

### 220+210, 2 wavelet

![220+210, 2 wavelet](wav2_210.png)

<a id="wav2_d221"></a>

### 220+221, negative mode, 2 wavelet

![220+221, negative mode, 2 wavelet](wav2_d221.png)

<a id="wav2_d210_320"></a>

### 220+210+320, negative mode, 2 wavelet

![220+210+320, negative mode, 2 wavelet](wav2_d210_320.png)

<a id="wav2_d440"></a>

### 220+440, negative mode, 2 wavelet

![220+440, negative mode, 2 wavelet](wav2_d440.png)

<a id="wav2_221"></a>

### 220+221, 2 wavelet

![220+221, 2 wavelet](wav2_221.png)

<a id="wav2_210_320"></a>

### 220+210+320, 2 wavelet

![220+210+320, 2 wavelet](wav2_210_320.png)

<a id="wav2_440"></a>

### 220+440, 2 wavelet

![220+440, 2 wavelet](wav2_440.png)

<a id="wav2_330_210"></a>

### 220+330+210, 2 wavelet

![220+330+210, 2 wavelet](wav2_330_210.png)

<a id="wav2_d330_210"></a>

### 220+330+210, negative mode, 2 wavelet

![220+330+210, negative mode, 2 wavelet](wav2_d330_210.png)

<a id="wav2_d330"></a>

### 220+330, negative mode, 2 wavelet

![220+330, negative mode, 2 wavelet](wav2_d330.png)

<a id="wav2_330"></a>

### 220+330, 2 wavelet

![220+330, 2 wavelet](wav2_330.png)

<a id="wav3_210_320"></a>

### 220+210+320, 3 wavelet

![220+210+320, 3 wavelet](wav3_210_320.png)
