%% c4_check_pa_data.m
%{
Description:
  This script analyzes the PA data. It computes and plots the AM–AM and
  AM-PM characteristics in order to visually assess its nonlinear behavior.

Input:
  - pa_data.mat
%}
clc; clear; close all;
tic

%% Functions folder
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Import data
% Load PA signals (complex)
load('pa_data.mat');

%% Plot
plot_amam(signal_1_in, signal_1_out);
plot_ampm(signal_1_in, signal_1_out);

plot_amam(signal_2_in, signal_2_out);
plot_ampm(signal_2_in, signal_2_out);

toc
