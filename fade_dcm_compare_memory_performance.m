% calculate Bayesian two-sample t-tests to compare memory performance
% assumes unequal variances (Welch's test)
% Bayes factor calculation uses bf.ttest from Bayes Factor Toolbox

num_cohorts = 2;
cohort_nums = [2, 3];
age_cutoff = 50;
var_assumed = 'unequal';
scaledef = sqrt(2)/2; % constant as defined in the Bayes factor toolbox

load dcm_params_w_demographics.mat
mem_results = {};

% main loop starts here
for coh = 1:num_cohorts
    coho = cohort_nums(coh);
    data_age_group1 = data_mem_Aprime{coho}(data_age{coho}<age_cutoff);
    data_age_group2 = data_mem_Aprime{coho}(data_age{coho}>=age_cutoff);
    N = [numel(data_age_group1), numel(data_age_group2)];
    % compute two-saple t-test with (here) unequal variances
    [h, p, ci, stats] = ttest2(data_age_group1, data_age_group2, 'Vartype', var_assumed);
    % compute Bayes factor using function bf.ttest
    [bf10, pval] = bf.ttest('T', stats.tstat, 'N', N, 'scale', scaledef);
    stats.p = p;
    stats.bf10 = bf10;
    mem_results{coho} = stats;
end

% display results
for coh = 1:num_cohorts
    coho = cohort_nums(coh);
    disp(sprintf('Results of cohort %d:\n', coho));
    disp(mem_results{coho});
end