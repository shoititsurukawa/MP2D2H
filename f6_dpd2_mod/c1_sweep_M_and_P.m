%% c1_sweep_M_and_P.m
%{
Description:
  This script models the DPD for different values of M and P and computes
  the NMSE for each of them.

Input:
  - pa_data.mat (f5_dpd1_demod)
%}
clc; clear; close all;
tic

%% Parameter sweep
M_values = 1:3;
P_values = 1:7;

%% Functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Importing data
root_folder = fileparts(current_folder);
demodulation_folder = fullfile(root_folder, 'f5_dpd1_demod');
mat_file = fullfile(demodulation_folder);
addpath(mat_file);
load('pa_data.mat');

%% Split data
% Extracttion
in_e1 = signal_1_out(1:3000);
in_v1 = signal_1_out(3001:end);
in_e2 = signal_2_out(1:3000);
in_v2 = signal_2_out(3001:end);
% Validation
out_e1 = signal_1_in(1:3000);
out_v1 = signal_1_in(3001:end);
out_e2 = signal_2_in(1:3000);
out_v2 = signal_2_in(3001:end);

%% Preallocate results matrix
% Columns: M, P, nmse_v1, nmse_v2, nmse_sum, num_parameters
results = [];

% Loop over M and P
for M = M_values
    for P = P_values
        %% Compute extraction X matrices
        [X_e1, X_e2] = MP2D2H(in_e1, in_e2, M, P);
        
        % Compute H matrix (Remember to remove first M+1 rows)
        H1 = X_e1(M+1:end, :) \ out_e1(M+1:end);
        H2 = X_e2(M+1:end, :) \ out_e2(M+1:end);
        
        %% Compute validation X matrices
        [X_v1, X_v2] = MP2D2H(in_v1, in_v2, M, P);
        
        % Predicted outputs
        out_v1_pred = X_v1 * H1;
        out_v2_pred = X_v2 * H2;
        
        %% Compute NMSE in dB
        nmse_v1 = compute_nmse(out_v1(M+1:end), out_v1_pred(M+1:end));
        nmse_v2 = compute_nmse(out_v2(M+1:end), out_v2_pred(M+1:end));
        
        % Convert to linear
        nmse_v1_lin = 10.^(nmse_v1/10);
        nmse_v2_lin = 10.^(nmse_v2/10);
        
        % Sum linear NMSE
        nmse_sum_lin = nmse_v1_lin + nmse_v2_lin;
        
        % Convert back to dB
        nmse_sum = 10 * log10(nmse_sum_lin);
        
        %% Number of parameters
        num_params = size(X_v1, 2);  % columns of X_v1
        
        %% Store results
        results = [results; M, P, nmse_v1, nmse_v2, nmse_sum, num_params];
    end
end

%% Display results
results_table = array2table(results, ...
    'VariableNames', {'M','P','NMSE_v1','NMSE_v2','NMSE_sum','Num_params'});
disp(results_table);

%% Display sorted results
% Sort by NMSE_sum (column 5) from most negative to most positive
[~, sort_idx] = sort(results(:,5), 'ascend');
results_sorted = results(sort_idx, :);

% Display the sorted results
disp('Sorted results (by NMSE_sum, ascending):');
disp(array2table(results_sorted, 'VariableNames', ...
    {'M','P','NMSE_v1','NMSE_v2','NMSE_sum','Num_parameters'}));

toc
