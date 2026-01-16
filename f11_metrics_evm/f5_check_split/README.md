## Workflow

## MATLAB

1. c1_split_data.m
   - Selects the signal duration (e.g., 80 µs or 1 ms).

2. c2_modulation.m  

3. c3_split_transmitted_signal.m  

## Cadence

- c7_pa_trans_part1
- c7_pa_trans_part2
- c7_pa_trans_part3
- c7_pa_trans_part4

Note:
- Verify in the schematic that the correct input file is selected for each segment.  
- Ensure that the simulation duration in Maestro matches the length of each signal segment.

## MATLAB

1. c4_resample_parts.m

2. c5_reconstruct_signal.m  

3. c6_demodulation.m  

4. c7_evm_format.m

## Cadence

- c5_wlan11n_evm_envlp

Note:
- Verify in the schematic the number of symbols (e.g., 11 or 241)..
