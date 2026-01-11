%% check_dpd.m
%{
Description:
  Demodulates the dual-band signal at the output of the PA, using the 
  resampled data from Cadence. The script recovers the baseband signals 
  transmitted on two RF carriers.

Input:
  - dpd_data.mat (f6_dpd2_mod)
  - pa_data.mat
%}
clc; clear variables; close all;
tic

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing DPD
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
dpd_modulation_folder = fullfile(root_folder, 'f6_dpd2_mod');
load(fullfile(dpd_modulation_folder, 'dpd_data.mat'));

% Changing names
s1_in_dpd  = signal_1_in;
s1_out_dpd = signal_1_out;
s2_in_dpd  = signal_2_in;
s2_out_dpd = signal_2_out;

%% Importing PA
load(fullfile(current_folder, 'pa_data.mat'));

% Changing names
s1_in_pa  = signal_1_in;
s1_out_pa = signal_1_out;
s2_in_pa  = signal_2_in;
s2_out_pa = signal_2_out;

%% Plot AM/AM
plot_amam(s1_in_dpd, s1_out_dpd)
plot_amam(s1_in_pa, s1_out_pa)
plot_amam(s1_in_dpd, s1_out_pa)

plot_amam(s2_in_dpd, s2_out_dpd)
plot_amam(s2_in_pa, s2_out_pa)
plot_amam(s2_in_dpd, s2_out_pa)

%% Plot AM/AM comparison for Signal 1
figure('Name','AM/AM Comparison - Signal 1','Color','w');
hold on; grid on; box on;

% PA only (blue)
plot(abs(s1_in_pa)/max(abs(s1_in_pa)), abs(s1_out_pa)/max(abs(s1_out_pa)), ...
    '.b', 'DisplayName', 'PA');

% DPD only (green)
plot(abs(s1_in_dpd)/max(abs(s1_in_dpd)), abs(s1_out_dpd)/max(abs(s1_out_dpd)), ...
    '.g', 'DisplayName', 'DPD');

% DPD + PA (red)
plot(abs(s1_in_dpd)/max(abs(s1_in_dpd)), abs(s1_out_pa)/max(abs(s1_out_pa)), ...
    '.r', 'DisplayName', 'DPD and PA');

xlabel('Normalized |Input Signal|');
ylabel('Normalized |Output Signal|');
legend('Location','northoutside','Orientation','horizontal');
set(gca,'FontSize',12,'LineWidth',1.2);
axis([0 1 0 1]);

%% Plot AM/AM comparison for Signal 2
figure('Name','AM/AM Comparison - Signal 2','Color','w');
hold on; grid on; box on;

% PA only (blue)
plot(abs(s2_in_pa)/max(abs(s2_in_pa)), abs(s2_out_pa)/max(abs(s2_out_pa)), ...
    '.b', 'DisplayName', 'PA');

% DPD only (green)
plot(abs(s2_in_dpd)/max(abs(s2_in_dpd)), abs(s2_out_dpd)/max(abs(s2_out_dpd)), ...
    '.g', 'DisplayName', 'DPD');

% DPD + PA (red)
plot(abs(s2_in_dpd)/max(abs(s2_in_dpd)), abs(s2_out_pa)/max(abs(s2_out_pa)), ...
    '.r', 'DisplayName', 'DPD and PA');

xlabel('Normalized |Input Signal|');
ylabel('Normalized |Output Signal|');
legend('Location','northoutside','Orientation','horizontal');
set(gca,'FontSize',12,'LineWidth',1.2);
axis([0 1 0 1]);

toc
