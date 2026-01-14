%% c1_split_data.m
%{
Description:
  Reads source data collected in Cadende, resamples them at a constant
  frequency and save it to .mat file.

Input:
  - lte_real.csv (f1_source_data)
  - lte_imag.csv (f1_source_data)
  - wlan11n_real.csv (f1_source_data)
  - wlan11n_imag.csv (f1_source_data)

Output:
  - source_signal_complete.mat
%}
clear; clc; close all;
tic

%% Parameters
freq_baseband = 123e6;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(fileparts(current_folder));
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Path
source_folder = fullfile(root_folder, 'f1_source_data');

%% Importing data
[s1_time, s1_amp] = read_complex_csv(fullfile(source_folder, 'lte_real.csv'), fullfile(source_folder, 'lte_imag.csv'));
[s2_time, s2_amp] = read_complex_csv(fullfile(source_folder, 'wlan11n_real.csv'), fullfile(source_folder, 'wlan11n_imag.csv'));

%% Data parameters
% Number of points
s1_N = length(s1_amp)
s2_N = length(s2_amp)

% Time duration
s1_duration = s1_time(end)
s2_duration = s2_time(end)
resample_duration = min(s1_duration, s2_duration)

% Average sampling frequency
freq_sampling_1 = s1_N/s1_duration
freq_sampling_2 = s2_N/s2_duration

%% Plot
plot_spectrum(s1_amp, freq_sampling_1, 'Signal 1')
plot_spectrum(s2_amp, freq_sampling_2, 'Signal 2')

%% Resample
% Creating baseband time vector
time_baseband_complete = (0: freq_baseband*resample_duration).' / freq_baseband;

% Computing interpolation
s1_baseband_complete = interp1(s1_time, s1_amp, time_baseband_complete, 'makita', 'extrap');
s2_baseband_complete = interp1(s2_time, s2_amp, time_baseband_complete, 'makita', 'extrap');

%% Plot
plot_spectrum(s1_baseband_complete, freq_baseband, 'Signal 1')
plot_spectrum(s2_baseband_complete, freq_baseband, 'Signal 2')

%% Save
complete_file = fullfile(current_folder, 'source_signal_complete.mat');
save(complete_file, 'time_baseband_complete', 's1_baseband_complete', 's2_baseband_complete', '-v7.3');
fprintf('Saved: %s (%d samples)\n', complete_file, length(time_baseband_complete));

toc
