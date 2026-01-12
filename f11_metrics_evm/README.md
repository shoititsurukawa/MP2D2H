## Method to Compute EVM

The computation of the Error Vector Magnitude (EVM) involves multiple processing stages and interactions between MATLAB and Cadence simulations, which makes the overall procedure complex. To ensure correctness and facilitate debugging, the EVM evaluation is divided into a set of verification steps.

## f1_check_esquematic

First we are going to check if the squematic and maestro settings are correct in Cadence, so we are only converting the input signal previus collected from .csv to .pwl version. The EVM results obtained in this verification step are summarized below:

| Signal   | Number of Data Symbols | Elapsed Time (Wall Clock) | EVM (%)   |
|----------|------------------------|---------------------------|-----------|
| WLAN11N  | 1                      | 32.9 s                    | 6.91738 n |
| WLAN11N  | 241                    | 793 s (13 m 12.6 s)       | 42.1606 n |
| LTE      | —                      | 1.03 ks (17 m 11.6 s)     | 23.1203 n |
