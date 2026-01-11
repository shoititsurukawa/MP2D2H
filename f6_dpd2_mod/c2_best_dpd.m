%% c2_best_dpd.m
%{
Description:
  This script computes the DPD for specific M and P values and saves the
  result as a .pwl file.

Input:
  - pa_data.mat (f5_dpd1_demod)

Output:
  - dpd_coefficients.mat
%}
clc; clear; close all;
tic

%% Parameters
M = 3; P = 4;
save_dpd = true;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing data
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
demodulation_folder = fullfile(root_folder, 'f5_dpd1_demod');
addpath(demodulation_folder);
load('pa_data.mat');

%% Split extraction and validation data
% Note: For DPD, input = PA output, output = PA input
in_e1 = signal_1_out(1:3000);
in_v1 = signal_1_out(3001:end);
in_e2 = signal_2_out(1:3000);
in_v2 = signal_2_out(3001:end);

out_e1 = signal_1_in(1:3000);
out_v1 = signal_1_in(3001:end);
out_e2 = signal_2_in(1:3000);
out_v2 = signal_2_in(3001:end);

%% Computing model with extraction data
% Compute X matrix
[X_e1, X_e2] = MP2D2H(in_e1, in_e2, M, P);

% Compute H matrix (Remember to remove first M+1 rows)
H1 = X_e1(M+1:end, :) \ out_e1(M+1:end);
H2 = X_e2(M+1:end, :) \ out_e2(M+1:end);

%% Predicted output using validation data
% Compute X matrix
[X_v1, X_v2] = MP2D2H(in_v1, in_v2, M, P);

% Compute predicted output
out_v1_pred = X_v1 * H1;
out_v2_pred = X_v2 * H2;

%% Plot
figure()
plot(abs(in_v1), abs(out_v1_pred), '*k');
hold on
plot(abs(in_v1), abs(out_v1), '.r');
xlabel('|Input|');
ylabel('|Output|');

figure()
plot(abs(in_v2), abs(out_v2_pred), '*k');
hold on
plot(abs(in_v2), abs(out_v2), '.r');
xlabel('|Input|');
ylabel('|Output|');

%% Compute NMSE
nmse_v1 = compute_nmse(out_v1(M+1:end), out_v1_pred(M+1:end))
nmse_v2 = compute_nmse(out_v2(M+1:end), out_v2_pred(M+1:end))

%% Save max values
max_out_e1 = max(abs(in_e1))
max_out_e2 = max(abs(in_e2))

%% Save
if save_dpd
    script_folder = fileparts(mfilename('fullpath'));
    mat_filename = fullfile(script_folder, 'dpd_coefficients.mat');
    
    save(mat_filename, 'H1', 'H2', 'M', 'P', 'max_out_e1', 'max_out_e2', '-v7.3');
    disp(['DPD saved in ', mat_filename]);
end

toc
