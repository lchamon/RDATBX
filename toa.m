function [ L fb ] = toa( x, iMin, iMax, REF, Fs )
% Third-Octave Band Analysis
% x			Signal
% iMin		Minimum frequency ISO index
% iMax		Maximum frequency ISO index
% REF		Reference (for SPL, 2e-5)
% Fs		Sampling rate

% When left blank, the default parameters are appropriate for typical acoustic signals:
%		iMin = -16 (30 Hz)
%		iMax = 12 (16 kHz)
%		REF = 2e-5 (SPL)
%		Fs = 44.1 kHz
%
% ISO     Nominal      Lower cut    Upper cut
% index   frequency    frequency    frequency
%
% 13      20000.00     17959.39     22627.42
% 12      16000.00     14254.38     17959.39
% 11      12500.00     11313.71     14254.38
% 10      10000.00      8979.70     11313.71
%  9       8000.00      7127.19      8979.70
%  8       6300.00      5656.85      7127.19
%  7       5000.00      4489.85      5656.85
%  6       4000.00      3563.59      4489.85
%  5       3150.00      2828.43      3563.59
%  4       2500.00      2244.92      2828.43
%  3       2000.00      1781.80      2244.92
%  2       1600.00      1414.21      1781.80
%  1       1250.00      1122.46      1414.21
%  0       1000.00       890.90      1122.46
% -1        800.00       707.11       890.90
% -2        630.00       561.23       707.11
% -3        500.00       445.45       561.23
% -4        400.00       353.55       445.45
% -5        315.00       280.62       353.55
% -6        250.00       222.72       280.62
% -7        200.00       176.78       222.72
% -8        160.00       140.31       176.78
% -9        125.00       111.36       140.31
% -10       100.00        88.39       111.36
% -11        80.00        70.15        88.39
% -12        63.00        55.68        70.15
% -13        50.00        44.19        55.68
% -14        40.00        35.08        44.19
% -15        31.50        27.84        35.08
% -16        25.00        22.10        27.84
% -17        20.00        17.54        22.10
% -18        16.00        13.92        17.54
% -19        12.50        11.05        13.92
% -20        10.00         8.77        11.05
% -21         8.00         6.96         8.77
% -22         6.30         5.52         6.96
% -23         5.00         4.38         5.52
% -24         4.00         3.48         4.38
% -25         3.15         2.76         3.48
% -26         2.50         2.19         2.76
% -27         2.00         1.74         2.19
% -28         1.60         1.38         1.74
% -29         1.25         1.10         1.38
% -30         1.00         0.87         1.10


if nargin == 1
    iMin = -16;
    iMax = 12;
    REF = 2e-5;
    Fs = 44100;
end

fi = iMax:-1:iMin;	% Flipped frequency index
nb = length(fi);	% Number of bands

fm = 2.^(fi./3) * 1000;		% Exact central frequency [Hz]
f1 = 2^(-1/(2*3)) .* fm;	% Lower cut frequency [Hz]
f2 = 2^(1/(2*3)) .* fm;		% Upper cut frequency [Hz]

q = floor(Fs/2) / f2(1);	% Ratio between sampling frequency and
							% maximum frequency in analysis

if q < 1
	error('rdatbx:nyquistError', 'The sampling frequency is too low to reach the upper cut frequency of the last band!');
end

while q > 2
    x = decimate(x,2);
    Fs = floor(Fs/2);
    q = floor(Fs/2) / f2(1);
end


% Building third octave band filters and filtering signal
N = 12; % Filter order
L = zeros(1,nb); % Level vector

for n = 1:nb
    q = floor(Fs/2) / f2(n); % Ratio between sampling frequency and
                             % upper cut frequency
    while q > 2
        x = decimate(x,2);
        Fs = floor(Fs/2);
        q = floor(Fs/2) / f2(n);
    end

    [b a] = butter( N, [f1(n)/(Fs/2) f2(n)/(Fs/2)] );
    xfilt = filter( b, a, x );
    L(n) = 10*log10( var(xfilt)/(REF)^2 );
end

L = fliplr(L);


% ISO nominal central freq.
fb = [ 1, 1.25, 1.6, 2, 2.5, 3.15, 4, 5, 6.3, 8, 10, 12.5, 16, 20,...
      25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400,...
      500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000,...
      6300, 8000, 10000, 12500, 16000, 20000];

% Freq. bands nominal freq. vector
fb = fb( [iMin:iMax] + 31 );


% Plot
figure();
bar( 1:length(L), L, 0.8 );
set( gca, 'XTick', 1:4:length(L) );
set( gca, 'XTickLabel', arrayfun(@num2str, fb(1:4:length(L)), 'UniformOutput', false) );
title( 'Third-octave bands analysis' );
xlabel( 'Frequency [Hz]' );
ylabel( 'dB' );
