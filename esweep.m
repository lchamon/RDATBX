function [ s inv ] = esweep( f1, f2, t, A )
% Exponential sine sweep
% f1	Start frequency
% f2	End frequency
% t		Duration (seconds)
% A		Signal amplitude (< 1, if you intend to export a .wav file)
%
% The duration of the sweep is adjusted to guarantee that harmonics
% are in-phase, i.e., the actual sweep duration will not necessarily
% be exactly t seconds.
%
% For more informations see
% [Novák, Simon, Kadlec, Lotton. "Nonlinear System Identification Using Exponential Swept-Sine Signal" ]


%%%%%%% Sweep duration quantization
L = round( t / log(f2/f1) );

if L == 0
    L = 1;
end


%%%%%%% Sweep generation
n = 0 : 1/44100 : L*log(f2/f1);					% Index
s = A * sin( 2*pi*f1*L * (exp(n/L) - 1) );		% Frequency sweep
inv = f1*exp(-n/L) .* fliplr(s) / L;			% Inverse filter

end
