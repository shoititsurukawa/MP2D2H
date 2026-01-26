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

This stage follows the same procedure as f4_check_dpd_pa. However, instead of performing the simulation in a single run, the process is split into segments, which are simulated independently and then recombined.

### Segmentation Trade-offs and Constraints

| Signal   | num_of_parts | EVM (%)   |
|----------|--------------|-----------|
| WLAN11N  |  4           | 673.407 m |
| WLAN11N  |  6           | 647.426 m |
| WLAN11N  |  12          | 2.19402   |

Note: Only the first 80 µs of the frame is used in these tests.

In the next step, the goal is to process the full 1 ms frame using segmented simulations. When using only 4 segments, the simulation time of the first segment was excessively long. Since the compute server automatically resets every 24 hours, it was not possible to complete even a single simulation segment.

To address this, the signal was further split into a larger number of segments (12). However, before committing to a long full-frame simulation, the segmentation approach was re-evaluated using the shorter 80 µs signal. This test revealed a significant degradation in EVM as the number of segments increased, indicating that a higher number of segments introduces additional numerical distortion.

Based on this observation, the next simulations will be performed using 6 segments, which represents a compromise between simulation time and numerical accuracy. This configuration is expected to complete within the 24-hour limit while avoiding excessive degradation due to segmentation.

## f6_compute_evm

Simulation using the full 1 ms frame, divided into six segments:

| Part | Elapsed Time (Wall Clock) | Storage |
|------|---------------------------|---------|
| 1    | 46.8 ks (13h 0m 24s)      | 45 GB   | 
| 2    | 50.9 ks (14h 8m 25s)      | 47 GB   |
| 3    | 47.6 ks (13h 13m 37s)     | 45 GB   |
| 4    | 55.3 ks (15h 22m 16s)     | 49 GB   |
| 5    | 51.7 ks (14h 21m 42s)     | 48 GB   |
| 6    | 15 ks (4h 10m 10s)        | 20 GB   |

The simulation is currently not working. The suspected issue is in segment 6, where at approximately 148 µs the input voltage suddenly rises to about 7.5 V, after which the signal is lost.

Despite this issue, it was still possible to run the simulation and compute the EVM for the WLAN11N signal using 11 data symbols, resulting in an EVM of approximately 140 %.

However, when attempting to compute the EVM for the LTE signal, the following error occurred, even though no Cadence settings had been changed:

ERROR (SPCRTRF-15357): Cannot perform measurement because wprobe 'WPRB1' is not synchronized. To solve the problem, verify that: 1) The wireless probe is connected to the first harmonic of the envelope signal. When the wireless source is set to baseband mode, the frequency of the LO sources in the circuit must be set to the frequency set in the envelope analysis. This is usually set by the W0_wfreq variable. 2) If there is a delay in the circuit at the point connected to the wireless probe, increase the number of frames in the wireless source and rerun the simulation so that at least one full frame is present at the probe to be decoded. 3) Decrease the delay time if it is too long.
