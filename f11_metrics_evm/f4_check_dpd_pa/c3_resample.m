%% c1_resample.m
%{
Description:
  Resamples the Cadence data to a constant sampling rate of in the
  passband. The resampled signals are then saved into a .mat file. Only the
  output signal.

Input:
  - output_pa.csv

Output:
  - pa_resampled.mat
%}
clear; clc; close all;
tic

%% Parameters
fs_target = 28e9;            % Target sampling frequency [Hz]
ts_target = 1 / fs_target;   % Target sampling period [s]

%% Read input and output files
output_data = readmatrix('output_pa.csv');

time_orig = output_data(:,1);
signal_out = output_data(:,2);

%% Data parameters
% Average sampling frequency
freq_sampling_out = length(signal_out)/time_orig(end)

%% Create new uniform time base
t_min = time_orig(1);
t_max = time_orig(end);
time_uniform = (t_min:ts_target:t_max).';

%% Resample both signals using interpolation
signal_out_resampled = interp1(time_orig, signal_out, time_uniform, 'makima', 'extrap');

%% Save results
script_folder = fileparts(mfilename('fullpath'));
mat_filename = fullfile(script_folder, 'pa_resampled.mat');

save(mat_filename, 'time_uniform', 'signal_out_resampled', '-v7.3');
disp(['Signals resampled and saved in ', mat_filename]);

toc
