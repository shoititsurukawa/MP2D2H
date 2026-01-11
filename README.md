## MP2D2H

MP2D2H stands for Memory Polynomial, Two-Dimensional (dual-channel), with two carrier harmonics. This project implements a dual-band digital predistortion (DPD) framework for power amplifier linearization, where the second carrier frequency is the second harmonic of the first (2 GHz and 4 GHz).

## Signal Description

Signal 1 corresponds to an LTE signal with a carrier frequency of 2 GHz.  
Signal 2 corresponds to a WLAN11N signal with a carrier frequency of 4 GHz.

All simulations were executed using the same PA described in [1].

## Folder Structure

 - f0_function
Contains general-purpose MATLAB functions used throughout the project.

 - f1_source_data
Contains the input signal (LTE and WLAN11N).

 - f2_pa_mod
Contains scripts for PA modulation.

 - f3_pa_demod
Contains scripts for PA demodulation.

 - f4_dpd1_mod
Contains scripts for the first DPD modulation iteration.

 - f5_dpd1_demod
Contains scripts for the first DPD demodulation iteration.

 - f6_dpd2_mod
Contains scripts for the second DPD modulation iteration.

 - f7_dpd2_demod
Contains scripts for the second DPD demodulation iteration.

 - f8_metrics_pae
Contains scripts to compute power-added efficiency (PAE) and drain_efficiency.

 - f9_adjust_output_power
Contains scripts used to adjust and equalize output power levels.

 - f10_metrics_psd
Contains scripts to compute power spectral density (PSD).

Note: In both folders and scripts, the term "check" is used for intermediate verification and debugging purposes and may be ignored.

## Software and Environment

MATLAB Version: 9.6.0.1072779 (R2019a)  
Cadence Virtuoso Version: IC23.1-64b

## References

[1] Schuartz, L., Silva, R.G., Hara, A.T. et al. "Concurrent Tri-band CMOS Power Amplifier Linearized by 3D Improved Memory Polynomial Digital Predistorter." Circuits, Systems, and Signal Processing 40, 2176–2208 (2021). https://doi.org/10.1007/s00034-020-01581-w
