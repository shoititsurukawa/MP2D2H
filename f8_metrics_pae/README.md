## Workflow

The goal of this workflow is to compare PA performance with and without DPD under the same output power condition. This is required to ensure a fair comparison of efficiency and PAE metrics.

1. With DPD case
   
   f7_metrics_pae  >  f1_dpd

   - Computes the PA output power when DPD is applied.
   - Uses demodulated PA data copied from f7_dpd2_demod.

2. Output Power Matching
   
   f8_adjust_output_power

   - Determines the gain value required to adjust the transmitted_signal (input) such that the PA produces the same output power obtained in the DPD case.
   - This ensures that both cases are evaluated at an identical output power operating point.

3. No-DPD case
   
   f7_metrics_pae  >  f2_no_dpd

   - Runs the PA without DPD using the adjusted input power found in the previous step.
