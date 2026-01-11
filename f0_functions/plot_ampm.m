function plot_ampm(signal_in, signal_out)
%{
Description:
  Plot AM-PM characteristic of a PA.

Inputs:
  signal_in  - complex input signal to the PA
  signal_out - complex output signal from the PA
%}

    % Prepare data
    abs_in = abs(signal_in);
    angle_in = angle(signal_in);
    angle_out = angle(signal_out);

    % Phase difference normalized to [-pi, pi]
    phase_diff = angle(exp(1j * (angle_out - angle_in)));

    % Plot
    figure('Name','AM-PM','Color','w');
    plot(abs_in, phase_diff, '.', 'MarkerSize', 5);
    xlabel('|Input|');
    ylabel('Phase Difference (rad)');
    title('AM-PM Characteristic');
    grid on;
end
