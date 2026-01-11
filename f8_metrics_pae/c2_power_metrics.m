%% c2_power_metrics.m
%{
Description:
  Computes DC power (P_dc), input RF power (P_in), output RF power (P_out),
  drain efficiency, and power added efficiency (PAE).

Input:
  - resampled_data.mat
%}
clear all; clc; close all;
tic

%% Parameters
R_out = 50;
v0 = 0.85;
v1 = 0.80;
v2 = 1.80;
v4 = 1.80;
v5 = -1.50;
v6 = -0.70;

%% Importing data
current_folder = fileparts(mfilename('fullpath'));
mat_file = fullfile(current_folder, 'resampled_data.mat');
load(mat_file);

%% Adjusting current sign 
% Cadence uses the convention that current is positive when it enters a node.
% Since I selected the positive terminal of each VDC source, the measured
% current becomes negative when it flows into the PA circuit.
% According to my convention, I want the current to be positive when it enters the PA.
i0 = -i0;
i1 = -i1;
i2 = -i2;
i4 = -i4;
i5 = -i5;
i6 = -i6;
i_in = -i_in;

%% DC power
P0 = mean(v0 * i0)
P1 = mean(v1 * i1)
P2 = mean(v2 * i2)
P4 = mean(v4 * i4)
P5 = mean(v5 * i5)
P6 = mean(v6 * i6)
P_dc = P0 + P1 + P2 + P4 + P5 + P6

%% AC power
P_in = mean(v_in .* i_in)
P_out = mean(v_out.^2/R_out);
fprintf('P_out = %.15f\n', P_out);

P_in_dBm = 10*log10(P_in/10^-3)
P_out_dBm = 10*log10(P_out/10^-3)

%% Metrics
drain_efficiency = 100 * P_out/P_dc
PAE = 100 * (P_out - P_in)/P_dc

%% Plot
figure('Name','DC Current i2');
plot(time_uniform, i2);
grid on; xlabel('Time [s]'); ylabel('Current [A]');

figure('Name','RF Output Voltage v_{out}');
plot(time_uniform, v_out, 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('Voltage [V]');

toc