%% c4_resample_parts.m
%{
Description:
  Resamples Cadence PA output of each split back to the original
  MATLAB time grid using saved metadata, and stores the result in .mat
  files for later reconstruction.

Input:
  - output_pa_part1.csv
  - transmitted_signal_part1_meta.mat
  - output_pa_part2.csv
  - transmitted_signal_part2_meta.mat
  - ...

Output:
  - resampled_part1.mat
  - resampled_part2.mat
  - ...
%}
clear; clc; close all;
tic

%% Parameters
num_of_parts   = 4;

%% Path
current_folder = fileparts(mfilename('fullpath'));

%% Loop over all parts
for k = 1:num_of_parts

    fprintf('Processing part %d / %d\n', k, num_of_parts);

    %% Importing Cadence Data
    cadence_file = fullfile(current_folder, ...
        sprintf('output_pa_part%d.csv', k));

    assert(isfile(cadence_file), ...
        'Cadence output not found: %s', cadence_file);

    output_data = readmatrix(cadence_file);
    time_out = output_data(:,1);
    signal_out = output_data(:,2);

    %% Importing Metadata
    meta_file = fullfile(current_folder, ...
        sprintf('transmitted_signal_part%d_meta.mat', k));

    assert(isfile(meta_file), ...
        'Metadata file not found: %s', meta_file);

    meta = load(meta_file);
    time_part = meta.meta.time_part;

    %% Resample
    signal_part = interp1(time_out, signal_out, time_part, 'makima');

    %% Save
    save_file = fullfile(current_folder, ...
        sprintf('resampled_part%d.mat', k));

    save(save_file, 'signal_part');

    fprintf('Saved: %s (samples = %d)\n\n', ...
        save_file, numel(signal_part));
end

disp('All parts resampled successfully.');

toc

