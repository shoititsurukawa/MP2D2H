function [time, signal] = read_complex_csv(real_file, imag_file)
%{
Description:
  Reads a complex signal from separate real and imag CSVs.

Inputs:
  real_file - Filename (string) of the CSV containing the real part
  imag_file - Filename (string) of the CSV containing the imaginary part

Outputs:
  time   - Time vector (from the first column of the real CSV)
  signal - Complex signal (real + 1j*imag)
%}

    % Read real and imaginary CSV files
    real_data = readmatrix(real_file);
    imag_data = readmatrix(imag_file);

    % Extract columns
    time = real_data(:,1);
    real_part = real_data(:,2);
    imag_part = imag_data(:,2);

    % Combine into complex signal
    signal = real_part + 1j*imag_part;
end