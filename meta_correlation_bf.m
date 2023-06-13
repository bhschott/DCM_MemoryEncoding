function [R, BF10] = meta_correlation_bf(rvals, nvals)
% calculates weighted mean correlation coefficient and computes cumulative
% Bayes factor based on the total sample size 
% written by Björn Schott 06/2023

    % Check the input arguments
    narginchk(2, 2);

    % Fisher z-transform the correlation coefficients
    zvals = atanh(rvals);

    % Calculate the weighted mean of Fisher z-transformed correlations
    % includes inverse Fisher z transformation
    R = tanh(sum(zvals .* nvals) / sum(nvals));

    % Calculate the weighted sum of the sample sizes
    totalN = sum(nvals);

    % Calculate the meta-analytic Bayes factor
    % uses code by Sam Schwarzkopf implemented in the Matlab Bayes Factor
    % Toolbox by Bart Krekelberg
    F = @(g,r,n) exp(((n-2)./2).*log(1+g)+(-(n-1)./2).*log(1+(1-r.^2).*g)+(-3./2).*log(g)+-n./(2.*g));
    BF10 = sqrt((totalN/2)) / gamma(1/2) * integral(@(g) F(g,R,totalN),0,Inf);
end


