function [x, y, ACPR_low, ACPR_upper, ACPR_mean] = temp_to_freq(in,fs,repetitions,pontos_para_media,Band)
%TEMP_TO_FREQ1 Summary of this function goes here
%   Detailed explanation goes here
N=2^floor(log2(length(in)/repetitions));
resolution=fs/N;
% w = hamming(N);
 w = hanning(N);
% w = kaiser(N);
% w = blackman(N);
for var1=1:repetitions
    x = w.*in(var1*N-N+1:var1*N);
%     x = in(var1*N-N+1:var1*N);
    y(:,var1) = fftshift(fft(x,N)/N);
end
if repetitions > 1
    z = mean((abs(y).^2/2/50)');
else
    z=abs(y).^2/2/50;
end

clear y x
a = (0:resolution:resolution*(N-1))' - resolution*N/2;
ACPR_low_abs = mean(z((N/2-floor(Band*1.5/resolution)):(N/2-floor(Band/2/resolution))))/mean(z(N/2-floor(Band/2.3/resolution):N/2+floor(Band/2.3/resolution)));
ACPR_upper_abs = mean(z((N/2+floor(Band/2/resolution)):(N/2+floor(Band*1.5/resolution))))/mean(z(N/2-floor(Band/2.3/resolution):N/2+floor(Band/2.3/resolution)));


ACPR_low = 10*log10(ACPR_low_abs);
ACPR_upper = 10*log10(ACPR_upper_abs);
ACPR_mean = 10*log10(mean([ACPR_low_abs ACPR_upper_abs]));

b = 10*log10(z/1e-3);
p = pontos_para_media;
for v = 1:floor(length(a)/p)
   x(v,1) = mean(a(1+(v-1)*p:v*p));
   y(v,1) = mean(b(1+(v-1)*p:v*p));
end

% figure
% plot(a,b,'m');
end