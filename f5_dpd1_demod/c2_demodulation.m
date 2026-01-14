%% c2_demodulation.m
%{
Description:
  Demodulates the dual-band signal at the output of the PA, using the 
  resampled data from Cadence. The script recovers the baseband signals 
  transmitted on two RF carriers.

Input:
  - pa_resampled.mat

Output:
  - pa_data.mat
%}
clear; clc; close all;
tic

%% Parameters
freq_carrier_1 = 2.0e9;
bandwidth_1 = 8*20e6;
freq_carrier_2 = 4.0e9;
bandwidth_2 = 8*20e6;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Load PA data
% Path
resample_file = fullfile(current_folder, 'pa_resampled.mat')
data = load(resample_file);

% Structure
time_uniform = data.time_uniform;
signal_in_resampled = data.signal_in_resampled;
signal_out_resampled = data.signal_out_resampled;

% Stats
output_pa = signal_out_resampled;
N = length(output_pa);
fs = N / time_uniform(end);

%% Call demodulation function for PA output
[signal_1_out, signal_2_out, ~] = demodulate(signal_out_resampled, ...
    time_uniform, freq_carrier_1, freq_carrier_2, bandwidth_1, bandwidth_2, true);

%% Call demodulation function for PA input
[signal_1_in, signal_2_in, time_baseband] = demodulate(signal_in_resampled, ...
    time_uniform, freq_carrier_1, freq_carrier_2, bandwidth_1, bandwidth_2, true);

%% Print
max_s1_in = max(abs(signal_1_in))
max_s2_in = max(abs(signal_2_in))
max_s1_out = max(abs(signal_1_out))
max_s2_out = max(abs(signal_2_out))

%% Save results
mat_filename = fullfile(current_folder, 'pa_data.mat');

save(mat_filename, 'time_baseband', ...
    'signal_1_in', 'signal_2_in', ...
    'signal_1_out', 'signal_2_out', '-v7.3');

toc
