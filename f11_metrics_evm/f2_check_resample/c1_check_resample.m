%% c1_resample.m
%{
Description:
  This script apply only the resample to verify the error effect in the
  EVM.

Input:
  - lte_real.csv (f1_source_data)
  - lte_imag.csv (f1_source_data)
  - wlan11n_real.csv (f1_source_data)
  - wlan11n_imag.csv (f1_source_data)

Output:
  - lte_real.pwl
  - lte_imag.pwl
  - wlan11n_real.pwl
  - wlan11n_imag.pwl
%}
clear; clc; close all;
tic

%% Parameters
csv_files = {'lte_real.csv', 'lte_imag.csv', 'wlan11n_real.csv', 'wlan11n_imag.csv'};
interp_method = 'makima';   % 'linear' or 'makima'

%% Path
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(fileparts(current_folder));
source_folder = fullfile(root_folder, 'f1_source_data');

%% Process each CSV
for k = 1:numel(csv_files)
    csv_file = csv_files{k};
    csv_path = fullfile(source_folder, csv_file);

    [~, base_name, ~] = fileparts(csv_file);
    pwl_file = fullfile(current_folder, [base_name, '.pwl']);

    fprintf('Reading: %s\n', csv_path);

    % Read CSV data
    data = readmatrix(csv_path);
    time_orig = data(:,1);
    signal_orig = data(:,2);
    
    % Resample 1
    fs_target = 123e6;
    [time_new, signal_new] = resample(time_orig, signal_orig, fs_target, interp_method);
	
    % Resample 2
    fs_target = 28e9;
    [time_new, signal_new] = resample(time_new, signal_new, fs_target, interp_method);
	
    % Resample 3
    fs_target = 123e6;
    [time_new, signal_new] = resample(time_new, signal_new, fs_target, interp_method);
	
    % Resample back to time_orig
    signal_resampled = interp1(time_new, signal_new, time_orig, interp_method, 'extrap');

    % Combine time and signal into two columns
    data_to_save = [time_orig, signal_resampled];

    % Save to .pwl
    fid = fopen(pwl_file, 'w');
    if fid == -1
        error('Could not open %s for writing.', pwl_file);
    end

    fprintf(fid, '%.16e %.16e\n', data_to_save.');
    fclose(fid);

    fprintf('Saved as: %s\n\n', pwl_file);
end

disp('All files converted successfully!');
toc

function [time_new, signal_new] = resample(time_in, signal_in, fs_target, interp_method)
	% Compute new time vector
    t_min = time_in(1);
    t_max = time_in(end);
    ts_target = 1/fs_target;
    time_new = (t_min:ts_target:t_max).';

    % Perform interpolation
    signal_new = interp1(time_in, signal_in, time_new, interp_method, 'extrap');
end
