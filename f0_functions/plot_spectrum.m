function plot_spectrum(signal, fs, fig_name)
%{
Description:
  Plot magnitude and phase spectrum (paper-ready version).

Inputs:
  signal    - Input signal (time domain)
  fs        - Sampling frequency in Hz
  fig_name	- String to set as figure name (optional)
%}

    if nargin < 3
        fig_name = 'Frequency Spectrum';
    end

    % Compute FFT
    S = fft(signal);
    f_axis = linspace(-fs/2, fs/2, length(S));
    S_plot = fftshift(S);
    
    % Determine frequency units
    f_max = max(f_axis);
    if f_max >= 1e9
        f_axis_plot = f_axis / 1e9;
        freq_unit = 'GHz';
    else
        f_axis_plot = f_axis / 1e6;
        freq_unit = 'MHz';
    end

    % Plot
    figure('Name', fig_name, 'Color', 'w');

    ax1 = subplot(2,1,1);
    plot(f_axis_plot, 20*log10(abs(S_plot)), 'LineWidth', 1.2);
    xlabel(['Frequency (' freq_unit ')']);
    ylabel('Magnitude (dB)');
    grid on;

    ax2 = subplot(2,1,2);
    plot(f_axis_plot, unwrap(angle(S_plot)), 'LineWidth', 1.2);
    xlabel(['Frequency (' freq_unit ')']);
    ylabel('Phase (rad)');
    grid on;

    % Formatting for papers
    set([ax1, ax2],'FontSize',12,'LineWidth',1);
end