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
