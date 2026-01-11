function [signal_demod_1, signal_demod_2, time_baseband] = demodulate(signal_in, time_uniform, freq_carrier_1, freq_carrier_2, bw_filter_1, bw_filter_2, do_plot)
%{
Description:
  Demodulates a dual-band signal from passband to baseband using FFT-based
  filtering, inverse FFT and frequency downconversion.

Inputs:
  signal_in       - Input PA signal (time domain)
  time_uniform    - Time vector (uniform sampling)
  freq_carrier_1  - Carrier frequency of first signal (Hz)
  freq_carrier_2  - Carrier frequency of second signal (Hz)
  bw_filter_1     - Bandwidth for first signal (Hz)
  bw_filter_2     - Bandwidth for second signal (Hz)
  do_plot         - Boolean (true/false), whether to plot or not

Outputs:
  signal_demod_1  - Demodulated baseband signal for carrier 1
  signal_demod_2  - Demodulated baseband signal for carrier 2
  time_baseband   - Time in baseband
%}

    %% Parameters
    N = length(time_uniform);
    duration = time_uniform(end);
    fs = N / duration;

    %% FFT
    S_tx = fft(signal_in);
    f_axis = linspace(-fs/2, fs/2, N);
    S_tx_shifted = fftshift(S_tx);

    %% Bandpass filtering
    mask_1 = (abs(f_axis(:) - freq_carrier_1) <= bw_filter_1/2);
    mask_2 = (abs(f_axis(:) - freq_carrier_2) <= bw_filter_2/2);

    S_filtered_1 = 2 * S_tx_shifted .* mask_1;
    S_filtered_2 = 2 * S_tx_shifted .* mask_2;

    %% Optional plot
    if do_plot
        figure('Name','Filtered Spectrum','Color','w');
        plot(f_axis/1e9, 20*log10(abs(S_tx_shifted)), 'b','LineWidth',1.2); hold on;
        plot(f_axis/1e9, 20*log10(abs(S_filtered_1)), 'r','LineWidth',1.2);
        plot(f_axis/1e9, 20*log10(abs(S_filtered_2)), 'g','LineWidth',1.2);
        xlabel('Frequency (GHz)'); ylabel('Magnitude (dB)');
        legend('Input signal','Filtered 1','Filtered 2'); grid on;
    end

    %% IFFT to time domain
    s_filtered_1 = ifft(ifftshift(S_filtered_1));
    s_filtered_2 = ifft(ifftshift(S_filtered_2));

    %% Demodulation to baseband
    negative_carrier_1 = exp(-1i*2*pi*freq_carrier_1*time_uniform);
    negative_carrier_2 = exp(-1i*2*pi*freq_carrier_2*time_uniform);

    signal_demod_1 = s_filtered_1 .* negative_carrier_1;
    signal_demod_2 = s_filtered_2 .* negative_carrier_2;

    %% Resample
    % Creating baseband time vector
    freq_baseband = 123e6;
    time_baseband = (0: freq_baseband*duration+1).' / freq_baseband;

    % Computing interpolation
    signal_demod_1 = interp1(time_uniform, signal_demod_1, time_baseband, 'linear', 'extrap');
    signal_demod_2 = interp1(time_uniform, signal_demod_2, time_baseband, 'linear', 'extrap');

end
