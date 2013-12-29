function [ Sxx f ] = psd( X, Nd, N, Fs )
% Frequency analysis: Power (cross-)Spectrum Density estimation using Welch's method (50% overlap)
% (requires the Signal Processing Toolbox)
% X		Data
% Nd	Number of segments to average (ignored if N is provided)
% N		Segment length (0 to provide Nd)
% Fs	Sampling rate


if N == 0
    N = 2*length(X) / (Nd + 1);
    N = 2^nextpow2(N);
end

OVERLAP = N/2;

Nd = floor( 2*(length(X) - OVERLAP) / N );

% Spectrum estimate relative error (S/S^) [Bendat & Pearson, "Random Data Analysis"]
errLow = 1 / ( 1 + 2*sqrt( 1/Nd ) );
errHigh = 1 / ( 1 - 2*sqrt( 1/Nd ) );

X = X - mean(X);


%%%%%%% Sxx
[Sxx f] = pwelch(X, N, OVERLAP, N, Fs);

figure();
plot( f, 10*log10( abs(Sxx) ) );
title( 'G_{xx}' );
xlim( [0 Fs/2] );
xlabel( 'Frequency [Hz]' );
ylabel( 'dB' );

text( mean( get(gca,'xlim') ) / 2, mean( get(gca,'ylim') ), ...
		[num2str(errLow) '<= Relative error (S/S\^) <= ' num2str(errHigh)], ...
		'BackgroundColor',	'white',	...
		'EdgeColor',		'black'		...
	);

end
