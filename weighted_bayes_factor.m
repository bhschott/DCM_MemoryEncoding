function BFw = weighted_bayes_factor(varargin)
% combines Bayes factors from independent samples weighted by their 
% sample sizes
% Input: BF1, BF2, ... BFn, N1, N2, ..., Nn
% where BF1:n are matrices containing Bayes factors
% and N1:n are matrices containing the corresponding sample sizes.
% BF1:n and N1:n must have the same dimensions.

% Get the number of Bayes factor matrices
numMatrices = nargin / 2;

% Get the size of the matrices
[rows, cols] = size(varargin{1});

% Initialize the result matrix with ones
BFw = ones(rows, cols);

% Compute the harmonic mean of the sample sizes
harmonicMean = harmonic_mean(varargin{numMatrices + 1:end});

% Iterate over each element of the matrices
for i = 1:rows
    for j = 1:cols
        % Accumulate the weighted logarithms of the Bayes factors
        sumWeightedLogs = 0;
        
        % Accumulate the weighted logarithms
        for k = 1:numMatrices
            bf = varargin{k}(i, j);  % Bayes factor
            sampleSize = varargin{numMatrices + k}(i, j);  % Sample size
            
            % Compute the weighted logarithm of the Bayes factor
            weightedLog = (sampleSize / harmonicMean(i, j)) * log(bf);
            
            % Accumulate the weighted logarithms
            sumWeightedLogs = sumWeightedLogs + weightedLog;
        end
        
        % Compute the combined Bayes factor using the exponential function
        combinedBF = exp(sumWeightedLogs);
        
        % Assign the result
        BFw(i, j) = combinedBF;
    end
end


