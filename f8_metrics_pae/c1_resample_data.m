%% c1_resample_data.m
%{
Description:
  Resamples the Cadence data to a constant sampling rate of in the
  passband. The resampled signals are then saved into a .mat file.

Input:
  - i_in.csv, input_pa.csv, output_pa.csv
  - i0.csv, i1.csv, i2.csv, i4.csv, i5.csv, i6.csv

Output:
  - resampled_data.mat
%}
clear; clc; close all;
tic

%% Parameters
fs_target = 28e9;            % Target sampling frequency [Hz]
ts_target = 1 / fs_target;   % Target sampling period [s]

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Extracting time
current_folder = fileparts(mfilename('fullpath'));
i_in_file = fullfile(current_folder, 'i_in.csv');
i_in_data = readmatrix(i_in_file);

% Creating time vector 
time_orig = i_in_data(:,1);
t_min = time_orig(1);
t_max = time_orig(end);
time_uniform = (t_min:ts_target:t_max).';

%% Processing data
% AC data
i_in = resample_signal(fullfile(current_folder, 'i_in.csv'), time_orig, time_uniform);
v_in = resample_signal(fullfile(current_folder, 'input_pa.csv'), time_orig, time_uniform);
v_out = resample_signal(fullfile(current_folder, 'output_pa.csv'), time_orig, time_uniform);

% DC current
i0 = resample_signal(fullfile(current_folder, 'i0.csv'), time_orig, time_uniform);
i1 = resample_signal(fullfile(current_folder, 'i1.csv'), time_orig, time_uniform);
i2 = resample_signal(fullfile(current_folder, 'i2.csv'), time_orig, time_uniform);
i4 = resample_signal(fullfile(current_folder, 'i4.csv'), time_orig, time_uniform);
i5 = resample_signal(fullfile(current_folder, 'i5.csv'), time_orig, time_uniform);
i6 = resample_signal(fullfile(current_folder, 'i6.csv'), time_orig, time_uniform);

%% Save results
mat_filename = fullfile(current_folder, 'resampled_data.mat');

save(mat_filename, 'time_uniform', 'i_in', 'v_in', 'v_out',...
     'i0', 'i1', 'i2', 'i4', 'i5', 'i6', '-v7.3');
disp(['Signals resampled and saved in ', mat_filename]);

toc

%% Functions
function signal_resampled = resample_signal(filename, time_orig, time_uniform)
%{
Description:
  Reads signal data from a CSV file, extracts the amplitude values from the
  second column, and resamples them onto a uniform time grid using linear
  interpolation.

Inputs:
  filename       - String specifying the name or path of the CSV file
  time_orig      - Original (non-uniform) time vector obtained from Cadence
  time_uniform   - Target uniform time vector used for interpolation

Outputs:
  signal_resampled - Resampled signal aligned with the uniform time vector
%}

    % Read data from CSV
    data = readmatrix(filename);

    % Extract signal (2nd column)
    signal = data(:,2);

    % Resample using linear interpolation
    signal_resampled = interp1(time_orig, signal, time_uniform);
end
