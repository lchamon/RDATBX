function [ Rxy ds ] = delay( X, Y, Fs )
% Estimate delay between signals
% X		First signal
% Y		Second signal
% Fs	Sampling rate


%%%%%%% Cross-correlation
[ Rxy tau ] = xcorr( X, Y );

Rxy = Rxy( ceil(length(Rxy)/2):end );
tau = tau( ceil(length(tau)/2):end );


%%%%%%% Time delay
Ro = Rxy / ( var(X) * var(Y) )^0.25;
Ro = abs( hilbert(Ro) ).^2;
ds = find( Ro == max(Ro) );


%%%%%%% Output
figure();
plot( tau, abs(Rxy) );
title( 'r_{xy}' );
xlabel( 'Lag (samples)' );

fprintf( '\nDelay:\n' );
fprintf( '\tX -> Y:\t\t%.2f seconds (%d samples)\n', ds/Fs, ds );

end
