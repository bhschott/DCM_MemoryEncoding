function [Z, p] = fisherztest(r1, r2, n1, n2)
% Computes Fisher's Z and corresponding p value from two correlation 
% coefficients. Sample sizes must be provided.

% Compute Fisher's z-scores
z1 = 0.5 * log((1 + r1) / (1 - r1));
z2 = 0.5 * log((1 + r2) / (1 - r2));

% Compute standard errors
se1 = 1 / sqrt(n1 - 3);
se2 = 1 / sqrt(n2 - 3);

% Compute test statistic
Z = (z1 - z2) / sqrt(se1^2 + se2^2);

% Compute p-value
p = 2 * (1 - normcdf(abs(Z)));

