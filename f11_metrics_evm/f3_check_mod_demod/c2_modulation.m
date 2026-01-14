%% c2_modulation.m
%{
Description:
  This script implements the modulation stage for a dual-band system.
  Compared to the previous version, the main modification is the use of the 
  complete baseband signal, corresponding to a total duration of 1 ms, 
  instead of processing only the first 5k samples (approximately 41 us).

  This change is required because the computation of the Error Vector 
  Magnitude (EVM) must be performed over a complete signal frame. For LTE 
  signals, one full frame corresponds to 1 ms. Consequently, the signal 
  normalization is also performed over the entire waveform rather than a 
  truncated segment.

  In addition, instead of exporting the modulated signals as .pwl files,
  this script stores the results in .mat.

Input:
  - source_signal_complete.mat

Output:
  - transmitted_signal_complete.mat
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

%% Importing data
% Path
source_file = fullfile(current_folder, 'source_signal_complete.mat')

% Structure
data = load(source_file);
time_baseband = data.time_baseband_complete;
s1_baseband = data.s1_baseband_complete;
s2_baseband = data.s2_baseband_complete;

%% Normalization
s1_baseband = s1_baseband / max(abs(s1_baseband));
s2_baseband = s2_baseband / max(abs(s2_baseband));

%% Modulation
[freq_oversampling, time_oversampled, transmitted_signal] = modulate_makima(freq_carrier_1, freq_carrier_2, time_baseband, s1_baseband, s2_baseband, do_plot);

%% Gain
max_val = max(abs(transmitted_signal));
transmitted_signal = transmitted_signal / max_val;
transmitted_signal = transmitted_signal * gain;
check_max_value = max(abs(transmitted_signal))

%% Save in .mat file
% Get folder of current script
mat_filename = fullfile(current_folder, 'transmitted_signal_complete.mat');

% Save variables
save(mat_filename, 'time_oversampled', 'transmitted_signal', '-v7.3');

disp(['Data saved as: ', mat_filename]);

toc