%% c3_split_transmitted_signal.m
%{
Description:
  Reads the complete transmitted signal in .mat, splits it into
  num_of_parts and saves them as .pwl files.

Input:
  - transmitted_signal.mat

Output:
  - transmitted_signal_part1.pwl
  - transmitted_signal_part1_meta.mat
  - transmitted_signal_part2.pwl
  - transmitted_signal_part2_meta.mat
  - ...
%}
clear; clc; close all;
tic

%% Parameters
num_of_parts = 4;
overlap = 100e3;

%% Import data
% Path
current_folder = fileparts(mfilename('fullpath'));
mat_file = fullfile(current_folder, 'transmitted_signal.mat');

% Structure
data = load(mat_file);
time_oversampled = data.time_oversampled;
transmitted_signal = data.transmitted_signal;
clear data

%% Split
fprintf('The split files will be saved in: %s\n', current_folder);

%% Compute num_of_points
N = length(time_oversampled);
num_of_points = ceil(N / num_of_parts);

for k = 1:num_of_parts
    % Compute start and end indices
    start_idx = (k - 1) * (num_of_points) - overlap + 1;
    end_idx   = k * num_of_points;
    
    % First part (without overlap)
    if k == 1
        start_idx = 1;
    end
    
    % Last part
    if k == num_of_parts
        end_idx = N;
    end
    
    % Compute samples
    samples = end_idx - start_idx + 1;

    % Extract part
    time_part   = time_oversampled(start_idx:end_idx);
    signal_part = transmitted_signal(start_idx:end_idx);

    % Reset time to start at zero
    time_part = time_part - time_part(1);

    % Combine data
    data_to_save = [time_part, signal_part];

    % Save as .pwl file
    save_file = fullfile(current_folder, sprintf('transmitted_signal_part%d.pwl', k));
    fid = fopen(save_file, 'w');
    if fid == -1
        error('Could not open file %s for writing.', save_file);
    end
    fprintf(fid, '%.16e,%.16e\n', data_to_save.');
    fclose(fid);
    
    %% Save metadata
    meta.part_id   = k;
    meta.start_idx = start_idx;
    meta.end_idx   = end_idx;
    meta.num_parts = num_of_parts;
    meta.N_total   = N;
    meta.overlap   = overlap;
    meta.time_start_original = time_oversampled(start_idx);
    meta.time_end_original   = time_oversampled(end_idx);
    meta.time_part = time_part;

    meta_file = fullfile(current_folder, ...
        sprintf('transmitted_signal_part%d_meta.mat', k));

    save(meta_file, 'meta');
    
    %% Print
    fprintf('transmitted_signal_%d.pwl (%d samples, start_idx = %d, end_idx = %d, duration = %.8e s)\n', ...
        k, samples, start_idx, end_idx, time_part(end));
end

toc
