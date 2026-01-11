%% c1_modulation.m
%{
Description:
  This script implements the modulation for a dual-band system. It uses as
  input the data collected in Cadence sources. The transmitted signal
  is saved in a .pwl file.

Input:
  - source_signal_1 (f1_source_data)

Output:
  - transmitted_signal.pwl
%}
clear; clc; close all;
tic

%% Parameters
freq_carrier_1 = 2.0e9;
freq_carrier_2 = 4.0e9;
gain = 0.02;
do_plot = true;

%% Importing functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing data
% Path
source_folder = fullfile(root_folder, 'f1_source_data');
source_file = fullfile(source_folder, 'source_signal_1.mat')

% Structure
data = load(source_file);
time_baseband = data.time_baseband;
s1_baseband = data.s1_baseband;
s2_baseband = data.s2_baseband;

%% Normalization
s1_baseband = s1_baseband / max(abs(s1_baseband));
s2_baseband = s2_baseband / max(abs(s2_baseband));

%% Modulation
[freq_oversampling, time_oversampled, transmitted_signal] = modulate(freq_carrier_1, freq_carrier_2, time_baseband, s1_baseband, s2_baseband, do_plot);

%% Gain
max_val = max(abs(transmitted_signal));
transmitted_signal = transmitted_signal / max_val;
transmitted_signal = transmitted_signal * gain;
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
