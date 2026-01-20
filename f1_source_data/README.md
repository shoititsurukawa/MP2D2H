## Workflow

This section describes the execution order of MATLAB scripts and Cadence simulations to design the DPD for a given PA.

Notes:
1. Steps marked as "optional" are not required for routine execution, as the workflow has already been validated. However, they should be executed when adapting the code, changing parameters or validating new datasets.
2. In Maestro, for every transient (tran) analysis, verify that the stop time is correctly set based on the results from c1_modulation.
3. In c2_best_dpd, verify that the parameters M and P selected are the best according to the results from c1_sweep_M_and_P.

## Cadence

1. c1_lte_envlp
2. c2_wlan11n_envlp

## MATLAB

1. f1_source_data > c1_split_data
2. f1_source_data > c2_check_split (optional)
3. f2_pa_mod > c1_modulation

## Cadence

1. c3_pa_tran

## MATLAB

1. f3_pa_demod > c1_resample 
2. f3_pa_demod > c2_demodulation
3. f3_pa_demod > c3_check_modulation (optional)
4. f3_pa_demod > c4_check_pa_data (optional)

5. f4_dpd1_mod > c1_sweep_M_and_P
6. f4_dpd1_mod > c2_best_dpd
7. f4_dpd1_mod > c3_modulation.m

## Cadence

1. c3_pa_tran

## MATLAB

1. f5_dpd1_demod > c1_resample
2. f5_dpd1_demod > c2_demodulation  
3. f5_dpd1_demod > c3_check_dpd (optional)

4. f6_dpd2_mod > c1_sweep_M_and_P
5. f6_dpd2_mod > c2_best_dpd
6. f6_dpd2_mod > c3_modulation.m

## Cadence

1. c3_pa_tran

## MATLAB

1. f7_dpd2_demod > c1_resample
2. f7_dpd2_demod > c2_demodulation  
3. f7_dpd2_demod > c3_check_dpd (optional)
