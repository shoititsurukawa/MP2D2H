## Authors

PhD Student: Luiz Augusto Shoiti Tsurukawa  
Email: shoiti.tsurukawa@gmail.com | shoiti.tsurukawa@ufpr.br

Co-advisor: Prof. Dr. Luis Schuartz  
Email: luisschuartz@ufpr.br

Advisor: Prof. Dr. Eduardo Gonçalves de Lima  
Email: eduardo.lima@ufpr.br

## MP2D2H

MP2D2H stands for Memory Polynomial, 2-Dimensional (dual-channel), where the second carrier is located at the 2nd Harmonic frequency of the first (2 GHz and 4 GHz). This project implements a digital predistortion (DPD) framework for power amplifier linearization.

Signal 1 corresponds to an LTE signal centered at a carrier frequency of 2 GHz.  
Signal 2 corresponds to a WLAN11N signal centered at a carrier frequency of 4 GHz.

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
Contains scripts to compute power-added efficiency (PAE) and drain efficiency.

 - f9_adjust_output_power  
Contains scripts used to adjust and equalize output power levels.

 - f10_metrics_psd  
Contains scripts to compute power spectral density (PSD).

- f11_metrics_evm  
Contains scripts to compute error vector magnitude (EVM).

Note: In both folders and scripts, the term "check" is used for intermediate verification and debugging purposes and may be ignored.

## Large Simulation Data

All large simulation result files (*.mat) are not stored in this repository to keep it lightweight.

They can be downloaded here:  
https://drive.google.com/drive/folders/1_6boFFSlS5dwLmLvH2FhozGtIjMzG6KJ?usp=sharing

## Project Design Philosophy

This project intentionally contains a significant amount of redundant code with minor variations across scripts and folders.

This design choice was made deliberately to prioritize clarity, ease of understanding, development, and reproducibility of results, rather than code optimization or reuse. Each script and folder represents a well-defined experiment, check, or processing stage, allowing individual steps to be inspected, modified, and rerun independently.

This approach is especially prevalent in:
- Check scripts and folders, which are primarily used for debugging and validation.
- Cadence simulation cells, where similar configurations are duplicated with small changes to isolate specific effects or operating conditions.

## Software and Environment

MATLAB Version: 9.6.0.1072779 (R2019a)  
Cadence Virtuoso Version: IC23.1-64b

## References

[1] Schuartz, L., Silva, R.G., Hara, A.T. et al. "Concurrent Tri-band CMOS Power Amplifier Linearized by 3D Improved Memory Polynomial Digital Predistorter." Circuits, Systems, and Signal Processing 40, 2176–2208 (2021). https://doi.org/10.1007/s00034-020-01581-w
