function [freq_oversampling, time_oversampled, transmitted_signal] = modulate(freq_carrier_1, freq_carrier_2, time_baseband, s1_baseband, s2_baseband, do_plot)
%{
Description:
  Modulates a dual-band signal from baseband to passband using resampling
  to RF frequencies, shift to it respectively carrier frequency and then
  combined to generate the transmitted signal.

Inputs:
  freq_carrier_1  - Carrier frequency of first signal (Hz)
  freq_carrier_2  - Carrier frequency of second signal (Hz)
  time_baseband   - Time vector for the baseband signals (s)
  s1_baseband     - Complex baseband signal for carrier 1
  s2_baseband     - Complex baseband signal for carrier 2
  do_plot         - Boolean (true/false), whether to plot or not

Outputs:
  freq_oversampling   - Oversampling frequency used for RF modulation (Hz)
  time_oversampled    - Oversampled time vector (s)
  transmitted_signal  - Real-valued passband signal combining both signals
%}

    %% Resample to RF
    % Creating oversampled time vector
    freq_oversampling = 7 * max(freq_carrier_1, freq_carrier_2);
    duration = time_baseband(end) - time_baseband(1)
    time_oversampled = (0: freq_oversampling*duration).' / freq_oversampling;

    % Computing interpolation
    s1_oversampled = interp1(time_baseband, s1_baseband, time_oversampled);
    s2_oversampled = interp1(time_baseband, s2_baseband, time_oversampled);

    %% Shift
    % Computing carrier
    positive_carrier_1 = exp(1i*2*pi*freq_carrier_1*time_oversampled);
    positive_carrier_2 = exp(1i*2*pi*freq_carrier_2*time_oversampled);

    % Computing shift
    s1_passband = s1_oversampled .* positive_carrier_1;
    s2_passband = s2_oversampled .* positive_carrier_2;

    %% Transmitted signal
    % Combine signals
    transmitted_signal = real(s1_passband + s2_passband);
    
    %% Optional plot
    if do_plot
        % Frequency domain
        plot_spectrum(transmitted_signal, freq_oversampling, 'Transmitted Signal')

        % Time domain
        figure();
        plot(time_oversampled, transmitted_signal);
        xlabel('Time (s)');
        ylabel('Amplitude (V)');
        ax = gca;
        set(ax,'FontSize',12,'LineWidth',1);
    end
end
