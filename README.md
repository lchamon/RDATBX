RDATBX
======

Random Data Analysis Toolbox for MATLAB

These MATLAB Toolbox scripts are useful to study random data, time series, and audio signals.


Functions
---------

### basicStat

Performs various basic statistical analyses on time series (or similar signals), including mean, mean square, and variance estimation and stationarity test (non-parametric).


### delay

Evaluate the delay between two signals. Can be used for synchronizing signals from different sources or estimating source bearing. Uses (classical) cross-correlation, correlation coefficient, and the Hilbert transform to improve peak detection (see [Bendat & Pearson. "Random Data Analysis"]).


### psd

Estimates the Power Spectrum Density (PSD) using Welch's method with 50% overlap. Also estimates the relative error of the PSD estimate (ratio between the estimate and "actual" value). Details can be found in [Bendat & Pearson. "Random Data Analysis"].


### xpsd

Estimates the cross-spectrum (cross-PSD) using Welch's method with 50% overlap. Also estimates the relative error of the cross-PSD estimate (ratio between the estimate and "actual" value). Details can be found in [Bendat & Pearson. "Random Data Analysis"].


### estimatetf

Estimates the coherence and the transfer function frequency response. Provides the relative error of both estimates (can be used to find low SNR issues and study nonlinear characteristics of the system). Details can be found in [Bendat & Pearson. "Random Data Analysis"].


### toa

Evaluates the third-octave spectrum of the signal. Uses the multirate filtering method defined in the ISO standard.


### esweep

Generates an exponential sine sweep that with in-phase harmonics that permits nonlinear identification of systems (using a power series model). Also returns the matched filter that can be used to recover the impulse response (IR).
