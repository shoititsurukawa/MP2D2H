%% c4_evm_format.m
%{
Description:
  This script will resample back the baseband signal to the same time
  vector used in Cadence, and save the real and imaginary parts of the PA
  output in .pwl format.

Input:
  - pa_data.mat
  - wlan11n_real.csv (f1_source_data)
  - lte_real.csv (f1_source_data)

Output:
  - wlan11n_real.pwl
  - wlan11n_imag.pwl
  - lte_real.pwl
  - lte_imag.pwl
%}
clear; clc; close all;
tic

%% Import time_target
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(fileparts(current_folder));
source_folder = fullfile(root_folder, 'f1_source_data');

% Signal 1
csv_1_file = fullfile(source_folder, 'lte_real.csv');
csv_1_data = readmatrix(csv_1_file);
time_1_target = csv_1_data(:,1);
fprintf('Loaded %d time points from lte_real.csv.\n', length(time_1_target));

% Signal 2
csv_2_file = fullfile(source_folder, 'wlan11n_real.csv');
csv_2_data = readmatrix(csv_2_file);
time_2_target = csv_2_data(:,1);
fprintf('Loaded %d time points from wlan11n_real.csv.\n', length(time_2_target));

%% Import pa_data
mat_filename = fullfile(current_folder, 'pa_data.mat');
data = load(mat_filename);

time_baseband = data.time_baseband;
signal_1_out  = data.signal_1_out;
signal_2_out  = data.signal_2_out;

fprintf('Loaded PA data with %d samples.\n', length(time_baseband));

%% Resample
signal_1_target = interp1(time_baseband, signal_1_out, time_1_target, 'makima', 'extrap');
signal_2_target = interp1(time_baseband, signal_2_out, time_2_target, 'makima', 'extrap');

%% Split real and imaginary part
real_1_part = real(signal_1_target);
imag_1_part = imag(signal_1_target);
real_2_part = real(signal_2_target);
imag_2_part = imag(signal_2_target);

%% Save to PWL
save_pwl = @(filename, time, sig) ...
    write_pwl_file(filename, time, sig);

% Signal 1
pwl_1_real = fullfile(current_folder, 'lte_real.pwl');
save_pwl(pwl_1_real, time_1_target, real_1_part);
pwl_1_imag = fullfile(current_folder, 'lte_imag.pwl');
save_pwl(pwl_1_imag, time_1_target, imag_1_part);

% Signal 2
pwl_2_real = fullfile(current_folder, 'wlan11n_real.pwl');
save_pwl(pwl_2_real, time_2_target, real_2_part);
pwl_2_imag = fullfile(current_folder, 'wlan11n_imag.pwl');
save_pwl(pwl_2_imag, time_2_target, imag_2_part);

toc

%% Function
function write_pwl_file(pwl_file, time, signal)

    data_to_save = [time(:), signal(:)];

    fid = fopen(pwl_file, 'w');
    if fid == -1
        error('Could not open %s for writing.', pwl_file);
    end

    % Use space-separated values — NO COMMAS (Spectre requirement)
    fprintf(fid, '%.16e %.16e\n', data_to_save.');

    fclose(fid);

    fprintf('Saved as: %s\n', pwl_file);
end
