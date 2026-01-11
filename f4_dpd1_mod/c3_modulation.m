%% c3_modulation.m
%{
Description:
  This script implements modulation for a dual-band system. First, it
  applies the DPD and then saves the transmitted signal to a .pwl file. It
  also saves the DPD data into a .mat file.

Input:
  - source_signal_2 (f1_source_data)
  - dpd_coefficients.mat

Output:
  - dpd_data.mat
  - transmitted_signal.pwl
%}
clc; clear; close all;
tic;

%% Parameters
freq_carrier_1 = 2.0e9;
freq_carrier_2 = 4.0e9;
do_plot = true;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing source data
root_folder = fileparts(current_folder);
source_folder = fullfile(root_folder, 'f1_source_data');
addpath(source_folder);
load('source_signal_2.mat');

%% Importing DPD
load('dpd_coefficients');

%% Normalization
s1_baseband = 0.999 * max_out_e1 * s1_baseband/max(abs(s1_baseband));
s2_baseband = 0.999 * max_out_e2 * s2_baseband/max(abs(s2_baseband));

%% Apply DPD
% Compute X matrix
[X1, X2] = MP2D2H(s1_baseband, s2_baseband, M, P);

% Compute predicted output
s1_pred = X1 * H1;
s2_pred = X2 * H2;

%% Save DPD
script_folder = fileparts(mfilename('fullpath'));
mat_filename = fullfile(script_folder, 'dpd_data.mat');

signal_1_in = s1_baseband;
signal_2_in = s2_baseband;
signal_1_out = s1_pred;
signal_2_out = s2_pred;

save(mat_filename, 'time_baseband', ...
    'signal_1_in', 'signal_2_in', ...
    'signal_1_out', 'signal_2_out', '-v7.3');

%% Plot
plot_amam(s1_baseband, s1_pred);
plot_ampm(s1_baseband, s1_pred);
plot_amam(s2_baseband, s2_pred);
plot_ampm(s2_baseband, s2_pred);

%% Modulation
[freq_oversampling, time_oversampled, transmitted_signal] = modulate(freq_carrier_1, freq_carrier_2, time_baseband, s1_pred, s2_pred, do_plot);

% Optional: check
check_max_value = max(abs(transmitted_signal))

% Return time to start at zero
time_oversampled = time_oversampled - time_baseband(1);

%% Save in .pwl file
% Get folder of current script
script_folder = fileparts(mfilename('fullpath'));
pwl_filename = fullfile(script_folder, 'transmitted_signal.pwl');

% Combine time and signal into two columns
data_to_save = [time_oversampled, transmitted_signal];

% Open file
fid = fopen(pwl_filename, 'w');
if fid == -1
    error('Could not open file %s for writing.', pwl_filename);
end

% Write data as two columns: time, signal
% note the transpose for column-wise fprintf
fprintf(fid, '%.16e,%.16e\n', data_to_save.');
fclose(fid);

disp(['Data saved as: ', pwl_filename]);

toc
