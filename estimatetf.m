function [ L gamma f ] = estimatetf( IN, OUT, nFFT, Fs )
% Transfer function frequency response estimation
% IN		Input signal
% OUT		Output signal
% nFFT		Length of FFT
% Fs		Sampling rate


[Sxx f] = psd( IN, 0, nFFT, Fs );
close(gcf);
[Syy ~] = psd( OUT, 0, nFFT, Fs );
close(gcf);
[Sxy ~] = xpsd( IN, OUT, 0, nFFT, Fs );
close(gcf);

Nd = floor( 2*(length(IN) - nFFT/2) / nFFT );


%%%%%%% Coherence
figure();
gamma = abs(Sxy).^2 ./ ( Sxx .* Syy );

plot( f, abs(gamma) );
xlim( [0 Fs/2] );
ylim( [0 1] );
title( 'Coherence' );
xlabel( 'Frequency [Hz]' );
ylabel( '\gamma' );

%%%%%%% Coherence error
figure();
eps = sqrt(2)*(1 - gamma) ./ ( sqrt(gamma)*sqrt(Nd) );

plot( f, abs(eps) );
title( 'Coherence estimation error' );
xlim( [0 Fs/2] );
xlabel( 'Frequency [Hz]' );


%%%%%%% Transfer function (linear model)
figure();
L = Sxy ./ Sxx;

subplot(2,1,1);
plot( f, 20*log10( abs(L) ) );
title( 'Transfer function (linear model)' );
xlim( [0 Fs/2] );
xlabel( 'Frequency [Hz]' );
ylabel('dB');

subplot(2,1,2);
plot( f, unwrap(angle(L)) );
xlim( [0 Fs/2] );
xlabel( 'Frequency [Hz]' );
ylabel('rad');

%%%%%%% Transfer function (linear model) error
figure();
eps = sqrt(1 - gamma) ./ ( sqrt(gamma)*sqrt(2*Nd) );

plot( f, abs(eps) );
title('Transfer function (linear model) estimation error');
xlim( [0 Fs/2] );
xlabel( 'Frequency [Hz]' );

end
