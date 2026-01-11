%% c4_interpolation.m
%{
Description:
  Performs linear interpolation between two data points to estimate the
  gain required to achieve a specified target output power.
%}
clear; clc; close all;
tic;

%% Parameters
Gain = [0.02, 0.018407612855170];
Pout = [0.002086164306390, 0.001768384973332];
target_P_out = 0.001795940617391;

%% Interpolation
% Generate interpolation points
Gain_interp = linspace(min(Gain), max(Gain), 100);
Pout_interp = interp1(Gain, Pout, Gain_interp, 'linear');

% Compute corresponding gain (inverse interpolation)
target_gain = interp1(Pout, Gain, target_P_out, 'linear');
fprintf('target_gain = %.15f\n', target_gain);

%% Plot
figure;
plot(Gain, Pout, 'o', 'MarkerFaceColor', 'r', 'DisplayName', 'Data points');
hold on;
plot(Gain_interp, Pout_interp, '-b', 'LineWidth', 1.5, 'DisplayName', 'Linear interpolation');

% Mark the predicted point
plot(target_gain, target_P_out, 'ks', 'MarkerFaceColor', 'g', 'DisplayName', 'Predicted point');

grid on;
xlabel('Gain');
ylabel('P_{out}');
title('Linear Interpolation between Two Points');
legend('Location', 'best');

toc
