%% csv_to_pwl.m
%{
Description:
  Reads CSV files containing waveform data and saves them as .pwl files in
  the same folder as this script.

Input:
  - wlan11n_real.csv (f1_source_data)
  - wlan11n_imag.csv (f1_source_data)

Output:
  - wlan11n_real.pwl
  - wlan11n_imag.pwl
%}
clear; clc; close all;

%% Parameters
csv_files = {'wlan11n_real.csv', 'wlan11n_imag.csv'};

%% Path
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(fileparts(fileparts(current_folder)));
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
    time = data(:,1);
    signal = data(:,2);

    % Combine time and signal into two columns
    data_to_save = [time, signal];

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
