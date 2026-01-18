## Method to Compute EVM

The computation of the Error Vector Magnitude (EVM) involves multiple processing stages and interactions between MATLAB and Cadence simulations, which makes the overall procedure complex. To ensure correctness and facilitate debugging, the EVM evaluation is divided into a set of verification steps.

## f1_check_esquematic

First we are going to check if the squematic and maestro settings are correct in Cadence, so we are only converting the input signal previus collected from .csv to .pwl version. The EVM results obtained in this verification step are summarized below:

| Signal   | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|---------------------------|-----------|
| LTE      | 1.03 ks (17 m 11.6 s)     | 23.1203 n |
| WLAN11N  | 793 s (13 m 12.6 s)       | 42.1606 n |

## f2_check_resample

Until this point, all resampling operations have been performed using the interp1 function with the linear interpolation method. However, during development, a significant EVM was observed even when only the modulation and demodulation stages were applied, without passing through the PA. After extensive testing, the resampling stage became a primary suspect. Therefore, two alternative resampling methods are evaluated and compared in the following tests.

### f2_linear

| Signal   | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|---------------------------|-----------|
| LTE      | 1.03 ks (17m  7.5s)       | 983.908 m |
| WLAN11N  | 808 s (13m  27.7s)        | 298.458 m |

### f2_makima

| Signal   | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|---------------------------|-----------|
| LTE      |  1.04 ks (17m  18.6s)     | 37.6051 m |
| WLAN11N  |  796 s (13m  15.5s)       | 56.6352 m |

## f3_check_mod_demod

Based on the previous results, the modulation and demodulation stages were reimplemented with the interpolation method changed from linear to makima.

| Signal   | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|---------------------------|-----------|
| LTE      |  1.03 ks (17m  8.8s)      | 39.156 m  |
| WLAN11N  |  795 s (13m  15.5s)       | 55.4521 m |

## f4_check_dpd_pa

In this part the DPD was implemented, and the signal was passed in the PA. Previously, EVM was computed using the complete WLAN11N frame of 1 ms, corresponding to 241 data symbols. To reduce simulation time, the analysis is now restricted to the first 80 µs of the frame, corresponding to 11 data symbols, which significantly accelerates the Cadence simulations.

| Parameter                 | Value                   |
|---------------------------|-------------------------|
| Signal duration           | 80 µs                   |
| Maximum amplitude         | 0.0209                  |
| Elapsed time (wall clock) | 17.3 ks (4 h 48 m 31 s) |
| Storage usage             | 24 GB                   |

| Signal   | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|---------------------------|-----------|
| WLAN11N  |  52.5 s                   | 661.138 m |

## f5_check_split

This stage follows the same procedure as f4_check_dpd_pa. However, instead of performing the simulation in a single run, the process is split into four segments, which are simulated independently and then recombined.

### Test: Splitting into 4 Segments

| Signal   | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|---------------------------|-----------|
| WLAN11N  |  53 s                     | 673.407 m |

### Test: Splitting into 12 Segments

| Number of data symbols | envTime (µs) | EVM (%)   |
|------------------------|--------------|-----------|
| 1                      | 40           | 642.138 m |
| 2                      | 44           | 735.251 m |
| 3                      | 48           | 1.9594    |
| 4                      | 52           | 2.47197   |
| 5                      | 56           | 2.500044  |
| 6                      | 60           | 2.51064   |
| 7                      | 64           | 2.45221   |
| 8                      | 68           | 2.38298   |
| 9                      | 72           | 2.31194   |
| 10                     | 76           | 2.25341   |
| 11                     | 80           | 2.19402   |
