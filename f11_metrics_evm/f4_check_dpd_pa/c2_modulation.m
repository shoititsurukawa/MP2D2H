%% c2_modulation.m
%{
Description:
  This script implements the modulation stage for a dual-band system. It
  includes the DPD implementation and saves the transmitted signal in .pwl
  format.

Input:
  - source_signal.mat

Output:
  - transmitted_signal.mat
%}
clear; clc; close all;
tic

%% Parameters
freq_carrier_1 = 2.0e9;
freq_carrier_2 = 4.0e9;
gain = 0.02;
do_plot = true;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(fileparts(current_folder));
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing source data
% Path
source_file = fullfile(current_folder, 'source_signal.mat')

% Structure
data = load(source_file);
time_baseband = data.time_baseband;
s1_baseband = data.s1_baseband;
s2_baseband = data.s2_baseband;

%% Importing DPD
% Path
dpd_folder = fullfile(root_folder, 'f6_dpd2_mod')
dpd_file = fullfile(dpd_folder, 'dpd_coefficients.mat')
data = load(dpd_file);

% Structure
H1 = data.H1;
H2 = data.H2;
M = data.M;
P = data.P;
max_out_e1 = data.max_out_e1;
max_out_e2 = data.max_out_e2;

%% Normalization
s1_baseband = 0.999 * max_out_e1 * s1_baseband/max(abs(s1_baseband));
s2_baseband = 0.999 * max_out_e2 * s2_baseband/max(abs(s2_baseband));

%% Apply DPD
% Compute X matrix
[X1, X2] = MP2D2H(s1_baseband, s2_baseband, M, P);

% Compute predicted output
s1_pred = X1 * H1;
s2_pred = X2 * H2;

%% Modulation
[freq_oversampling, time_oversampled, transmitted_signal] = modulate_makima(freq_carrier_1, freq_carrier_2, time_baseband, s1_pred, s2_pred, do_plot);

% Optional: check
check_max_value = max(abs(transmitted_signal))

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
