%% c5_reconstruct_signal.m
%{
Description:
  Reconstructs the full transmitted signal from resampled parts
  by discarding the overlap at the beginning of each part (except
  the first one) and reconstructs the corresponding time vector.

Input:
  - resampled_part1.mat
  - transmitted_signal_part1_meta.mat
  - resampled_part2.mat
  - transmitted_signal_part2_meta.mat
  - ...

Output:
  - pa_resampled.mat
%}
clear; clc; close all;
tic

%% Parameters
num_of_parts = 4;

%% Path
current_folder = fileparts(mfilename('fullpath'));

%% Load metadata from first part
m0 = load(fullfile(current_folder, 'transmitted_signal_part1_meta.mat'));
meta0 = m0.meta;

N = meta0.N_total;

%% Preallocate
signal_out_resampled = zeros(N,1);
time_uniform = zeros(N,1);

%% Reconstruction pointer
write_idx = 1;

%% Loop over parts
for k = 1:num_of_parts

    %% Load metadata
    meta_file = fullfile(current_folder, ...
        sprintf('transmitted_signal_part%d_meta.mat', k));
    meta = load(meta_file);
    meta = meta.meta;

    %% Load resampled PA output
    part_file = fullfile(current_folder, sprintf('resampled_part%d.mat', k));
    part_data = load(part_file);

    signal_part = part_data.signal_part;
    time_part = meta.time_part;   % original input time vector

    %% Reconstruction logic
    if k == 1
        keep_idx = 1:numel(signal_part);
    else
        keep_idx = (meta.overlap + 1):numel(signal_part);
    end

    signal_keep = signal_part(keep_idx);
    time_keep   = time_part(keep_idx);

    %% Time alignment
    if write_idx > 1
        dt = meta.time_part(2) - meta.time_part(1);
        time_keep = time_keep - time_keep(1) + time_uniform(write_idx-1) + dt;
    end

    %% Write into reconstructed arrays
    n_keep = numel(signal_keep);

    idx_range = write_idx : write_idx + n_keep - 1;

    signal_out_resampled(idx_range) = signal_keep;
    time_uniform(idx_range) = time_keep;

    write_idx = write_idx + n_keep;
end

%% Trim (safety)
signal_out_resampled = signal_out_resampled(1:N);
time_uniform = time_uniform(1:N);

%% Save
resample_file = fullfile(current_folder, 'pa_resampled.mat');

save(resample_file, 'time_uniform', 'signal_out_resampled');

fprintf('Saved reconstructed PA output to:\n%s\n', resample_file);
disp('Signal and time reconstruction completed successfully.');

toc

