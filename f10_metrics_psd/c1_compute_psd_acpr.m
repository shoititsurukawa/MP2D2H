%% c1_compute_psd_acpr.m
%{
Description:
  Compute the PSD (Power Spectral Density) and ACPR
  (Adjacent Channel Power Ratio).

Input:
  - resampled_data.mat (f8_metrics_pae > f1_dpd)
  - resampled_data.mat (f8_metrics_pae > f2_no_dpd)
%}
clear; clc; close all;
tic

%% Parameters
freq_carrier_1 = 2.0e9;
bandwidth_1 = 20e6;
freq_carrier_2 = 4.0e9;
bandwidth_2 = 20e6;
fs = 123e6;
do_plot = false;
repetitions = 1;
smoth_factor = 3;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing Data
% With DPD
dpd_file = fullfile(root_folder, 'f8_metrics_pae', 'f1_dpd', 'resampled_data.mat');
dpd_data = load(dpd_file);
out_dpd = dpd_data.v_out;

% No DPD
no_dpd_file = fullfile(root_folder, 'f8_metrics_pae', 'f2_no_dpd', 'resampled_data.mat');
no_dpd_data = load(no_dpd_file);
time_uniform = no_dpd_data.time_uniform;
out_no_dpd = no_dpd_data.v_out;

%% Demodulation
% With DPD
[s1_dpd, s2_dpd, ~] = demodulate(out_dpd, ...
    time_uniform, freq_carrier_1, freq_carrier_2, 16*bandwidth_1, 8*bandwidth_2, do_plot);

% No DPD
[s1_no_dpd, s2_no_dpd, ~] = demodulate(out_no_dpd, ...
    time_uniform, freq_carrier_1, freq_carrier_2, 16*bandwidth_1, 8*bandwidth_2, do_plot);

%% PSD and ACPR Calculation
[x1_no_dpd, y1_no_dpd, ACPR_low_1_no_dpd, ACPR_upper_1_no_dpd, ACPR_mean_1_no_dpd] = ...
    temp_to_freq(s1_no_dpd, fs, repetitions, smoth_factor, bandwidth_1);
[x1_dpd, y1_dpd, ACPR_low_1_dpd, ACPR_upper_1_dpd, ACPR_mean_1_dpd] = ...
    temp_to_freq(s1_dpd, fs, repetitions, smoth_factor, bandwidth_1);

[x2_no_dpd, y2_no_dpd, ACPR_low_2_no_dpd, ACPR_upper_2_no_dpd, ACPR_mean_2_no_dpd] = ...
    temp_to_freq(s2_no_dpd, fs, repetitions, smoth_factor, bandwidth_2);
[x2_dpd, y2_dpd, ACPR_low_2_dpd, ACPR_upper_2_dpd, ACPR_mean_2_dpd] = ...
    temp_to_freq(s2_dpd, fs, repetitions, smoth_factor, bandwidth_2);

%% Print
fprintf('\n=== ACPR Results ===\n');
fprintf('Signal 1 (No DPD):  Lower = %.2f dB | Upper = %.2f dB | Mean = %.2f dB\n', ...
    ACPR_low_1_no_dpd, ACPR_upper_1_no_dpd, ACPR_mean_1_no_dpd);
fprintf('Signal 1 (With DPD): Lower = %.2f dB | Upper = %.2f dB | Mean = %.2f dB\n\n', ...
    ACPR_low_1_dpd, ACPR_upper_1_dpd, ACPR_mean_1_dpd);

fprintf('Signal 2 (No DPD):  Lower = %.2f dB | Upper = %.2f dB | Mean = %.2f dB\n', ...
    ACPR_low_2_no_dpd, ACPR_upper_2_no_dpd, ACPR_mean_2_no_dpd);
fprintf('Signal 2 (With DPD): Lower = %.2f dB | Upper = %.2f dB | Mean = %.2f dB\n', ...
    ACPR_low_2_dpd, ACPR_upper_2_dpd, ACPR_mean_2_dpd);

%% Plot
% Signal 1
figure('Name', 'Signal 1 PSD', 'Color', 'w');
plot(x1_no_dpd/1e6, y1_no_dpd, 'LineWidth', 1.5); hold on;
plot(x1_dpd/1e6, y1_dpd, '--', 'LineWidth', 1.5);
grid on;
xlabel('Frequency [MHz]');
ylabel('PSD [dBm/Hz]');
legend('No DPD', 'With DPD', 'Location', 'best');

% Signal 2fgdfg
figure('Name', 'Signal 2 PSD', 'Color', 'w');
plot(x2_no_dpd/1e6, y2_no_dpd, 'LineWidth', 1.5); hold on;
plot(x2_dpd/1e6, y2_dpd, '--', 'LineWidth', 1.5);
grid on;
xlabel('Frequency [MHz]');
ylabel('PSD [dBm/Hz]');
legend('No DPD', 'With DPD', 'Location', 'best');

toc
