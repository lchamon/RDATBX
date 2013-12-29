function [ m ms sigma2 STAT ] = basicStat( X )
% Perform various statistical analyses on time series (or similar data)
% X		Data (signal or time series)

% Number of segments
N = 20;

%%%%%%% Mean
m = mean( X );

%%%%%%% Mean square
ms = mean( X.^2 );

%%%%%%% Variance
sigma2 = var( X );

%%%%%%% Stationarity test (Reverse arrangements) [Bendat & Pearson, "Random Data Analysis"]
msN = zeros(1,N);
PIECE = floor( length(X) / N );

for i = 0:N-1
    msN(i+1) = mean( X( i*PIECE+1:(i+1)*PIECE ).^2 );
end

A = 0;
for i=1:N-1
    for j=i:N
        if(msN(i) > msN(j))
            A = A + 1;
        end
    end
end

if(A >= 64 && A <= 125)
    STAT = 'Stationary';		% p < 0.05
else
    STAT = 'Nonstationary';
end

%%%%%%% Output
fprintf('\n  Mean\t\t  Mean Square\t\tVariance\t\tStationarity\n');
fprintf('\n%f\t\t%f\t\t%f\t\t%s\n\n', m, ms, sigma2, STAT);

end
