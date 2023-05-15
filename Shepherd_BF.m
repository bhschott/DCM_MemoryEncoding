function [Pi BF10 p num_ol] = Shepherd_BF(a, b, num_it)
% Bayesian Shepherd's Pi correlation
% requires Shepherd's Pi correlation toolbox by Sam Schwarzkopf
%
% written bei Björn Schott, 02/2023
% 

if nargin < 3
    num_it = 10000;
end

[Pi p ol] = Shepherd(a, b, num_it);

% subtract outliers from number of observations
num_ol = sum(ol);
num_obs = length(ol);

n = num_obs - num_ol;
r = Pi;

% Code from Sam Schwarzkopf, taken from Bayes Factor toolbox
F = @(g,r,n) exp(((n-2)./2).*log(1+g)+(-(n-1)./2).*log(1+(1-r.^2).*g)+(-3./2).*log(g)+-n./(2.*g));
BF10 = sqrt((n/2)) / gamma(1/2) * integral(@(g) F(g,r,n),0,Inf);