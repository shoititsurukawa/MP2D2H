%% c2_check_split.m
%{
Description:
  Reads .mat files and plots them to check if they were correctly split.

Input:
  - source_signal_1.mat
  - source_signal_2.mat
  - source_signal_3.mat
  - source_signal_complete.mat
%}
clear; clc; close all;
tic

%% Load complete baseband data
current_folder = fileparts(mfilename('fullpath'));
complete_file = fullfile(current_folder, 'source_signal_complete.mat');
load(complete_file);

%% Load source segments
num_segments = 3;
source_data = cell(1, num_segments);

for k = 1:num_segments
    segment_file = fullfile(current_folder, sprintf('source_signal_%d.mat', k));
    tmp = load(segment_file);
    % Shift segment time to align with complete signal
    tmp.time_baseband = tmp.time_baseband + time_baseband_complete((k-1)*length(tmp.time_baseband)+1);
    source_data{k} = tmp;
end

% Define colors for segments: red, green, blue
segment_colors = [1 0 0; 0 1 0; 0 0 1]; % RGB

%% Plot real and imaginary part of Signal 1
figure('Name','Signal 1 Real & Imag Part','Color','w');

% Real part
subplot(2,1,1); hold on;
plot(time_baseband_complete, real(s1_baseband_complete), 'k', 'LineWidth', 1.5);
for k = 1:num_segments
    plot(source_data{k}.time_baseband, real(source_data{k}.s1_baseband), '--', ...
        'Color', segment_colors(k,:), 'LineWidth', 1.2);
end
xlabel('Time (s)');
ylabel('Amplitude');
legend_entries = [{'Complete'} arrayfun(@(k) sprintf('Segment %d', k), 1:num_segments, 'UniformOutput', false)];
legend(legend_entries);
grid on;
title('Real Part of Signal 1');

% Imaginary part
subplot(2,1,2); hold on;
plot(time_baseband_complete, imag(s1_baseband_complete), 'k', 'LineWidth', 1.5);
for k = 1:num_segments
    plot(source_data{k}.time_baseband, imag(source_data{k}.s1_baseband), '--', ...
        'Color', segment_colors(k,:), 'LineWidth', 1.2);
end
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
title('Imaginary Part of Signal 1');

%% Plot real and imaginary part of Signal 2
figure('Name','Signal 2 Real & Imag Part','Color','w');

%% Real part
subplot(2,1,1); hold on;
plot(time_baseband_complete, real(s2_baseband_complete), 'k', 'LineWidth', 1.5);
for k = 1:num_segments
    plot(source_data{k}.time_baseband, real(source_data{k}.s2_baseband), '--', ...
        'Color', segment_colors(k,:), 'LineWidth', 1.2);
end
xlabel('Time (s)');
ylabel('Amplitude');
legend_entries = [{'Complete'} arrayfun(@(k) sprintf('Segment %d', k), 1:num_segments, 'UniformOutput', false)];
legend(legend_entries);
grid on;
title('Real Part of Signal 2');

%% Imaginary part
subplot(2,1,2); hold on;
plot(time_baseband_complete, imag(s2_baseband_complete), 'k', 'LineWidth', 1.5);
for k = 1:num_segments
    plot(source_data{k}.time_baseband, imag(source_data{k}.s2_baseband), '--', ...
        'Color', segment_colors(k,:), 'LineWidth', 1.2);
end
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
title('Imaginary Part of Signal 2');

toc
