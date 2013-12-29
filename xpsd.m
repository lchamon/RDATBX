function [ Sxy f ] = xpsd( X, Y, Nd, N, Fs )
% Frequency analysis: Power (cross-)Spectrum Density estimation using Welch's method (50% overlap)
% (requires the Signal Processing Toolbox)
% X		First data
% Y		Second data
% Nd	Number of segments to average (ignored if N is provided)
% N		Segment length (0 to provide Nd)
% Fs	Sampling rate


if N == 0
    N = 2*length(X) / (Nd + 1);
    N = 2^floor( log2(N) );
end

OVERLAP = N/2;

Nd = floor( 2*(length(X) - OVERLAP) / N );

% Spectrum estimate relative error (S/S^) [Bendat & Pearson, "Random Data Analysis"]
errLow = 1 / ( 1 + 2*sqrt( 1/Nd ) );
errHigh = 1 / ( 1 - 2*sqrt( 1/Nd ) );


X = X - mean(X);
Y = Y - mean(Y);

%%%%%%% Sxy
if length(X) == length(Y)
    [ Sxy f ] = cpsd( X, Y, N, OVERLAP, N, Fs );

    figure();
    subplot(2,1,1);
    plot( f, 10*log10( abs(Sxy) ) );
    title( 'G_{xy}' );
    xlim( [0 Fs/2] );
	xlabel( 'Frequency [Hz]' );
	ylabel( 'dB' );
	
	text( mean( get(gca,'xlim') ) / 2, mean( get(gca,'ylim') ), ...
		[num2str(errLow) '<= Relative error (S/S\^) <= ' num2str(errHigh)], ...
		'BackgroundColor',	'white',	...
		'EdgeColor',		'black'		...
	);

    subplot(2,1,2);
    plot( f, unwrap( angle(Sxy) ) );
    xlim( [0 Fs/2] );
	xlabel( 'Frequency [Hz]' );
	ylabel( 'rad' );
else
	error( 'rdatbx:dimError', 'To calculate the cross-spectrum, X and Y must be the same length!' );
end

end
