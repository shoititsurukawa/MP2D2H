%% c3_compute_power.m
%{
Description:
  Compute the output power.

Input:
  - output_resampled.mat
%}
clear all; clc; close all;

%% Parameters
fs_target = 28e9;            % Target sampling frequency [Hz]
ts_target = 1 / fs_target;   % Target sampling period [s]
R_out = 50;

% Importing data
current_folder = fileparts(mfilename('fullpath'));
mat_file = fullfile(current_folder, 'output_resampled.mat');
data = load(mat_file);
signal_out_resampled = data.signal_out_resampled;

%% Metrics
P_out = mean(signal_out_resampled.^2/R_out);
fprintf('P_out = %.15f\n', P_out);
P_out_dBm = 10*log10(P_out/10^-3)
