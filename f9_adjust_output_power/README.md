## Output Power Matching Procedure (No-DPD Case)

To generate the transmitted signal for the no-DPD case, a copy of the script c1_modulation.m from the f2_pa_mod folder is used.

According to the results obtained in:

f8_metrics_pae  >  f1_dpd

the PA output power with DPD is:

P_out = 0.001795940617391 (2.5429 dB)

Therefore, the gain in c1_modulation.m must be adjusted such that the PA without DPD operates at the same output power (within a tolerance of ±0.1 dB). This ensures a fair and consistent comparison of all efficiency and PAE metrics.

## Workflow

The output power matching procedure follows the steps below.

1. Signal generation

   - Run c1_modulation.m to generate the transmitted signal for a given gain value.
   
   Note: Before running the script, set the parameter gain inside the code to the desired value.

2. PA simulation (Cadence)

   - The transmitted signal is applied to the PA in Cadence.
   - A transient simulation is executed.
   - The PA output waveform is exported as output_pa.csv.

3. Resampling

   - Run c2_resample_output.m to resamples the PA output signal.

   Note: The original .csv files were deleted due to their large size. The resample data is available in corresponding .mat files.

4. Output power computation

   - Run c3_compute_power.m to computes the PA output power.

5. Gain estimation

   - Only run this step once at least two data points are available.
   - Run c4_interpolation.m to the measured data to interpolate and estimate the gain required to reach the target output power.

   Note: Before running the script, manually input the closest data point for the linear interpolation.

6. Iteration

   - Steps 1–5 are repeated until:  
   P_out = 2.5429 dB ± 0.1 dB

## 1st Iteration

An initial data point is already available from f3_pa_demod.

Gain  = 0.02  
P_out = 0.002086164306390 (3.1935 dB)

## 2nd Iteration

Since the output power is higher than the target, the gain must be reduced.

gain = 0.015  
P_out = 0.001174879353038 (0.6999 dB)

## 3rd Iteration

Following the linear interpolation prediction.

gain = 0.018407612855170  
P_out = 0.001768384973332 (2.4758 dB)

## 4th Iteration

Following the linear interpolation prediction.

gain = 0.018545693745909  
P_out = 0.001794982381679 (2.5406 dB)
