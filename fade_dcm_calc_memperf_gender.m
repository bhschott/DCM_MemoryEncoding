% compute memory performance, separated by gender (and age, if applicable)
% separately for each cohort
% considers male and female gender only, as no participants identified
% as other
%
% written by Björn Schott, 08/2023

num_cohorts = 3;
num_agegroups = 2;
age_cutoff = 50;

load dcm_params_w_demographics.mat

gender_data = {};
ttest_results = {}; % Store t-test results
for coh = 1:num_cohorts
    for ag = 1:num_agegroups
        switch ag
            case 1
                data_f = data_mem_Aprime{coh}(data_gender{coh}==2 & data_age{coh}<age_cutoff);
                data_m = data_mem_Aprime{coh}(data_gender{coh}==1 & data_age{coh}<age_cutoff);
            case 2
                data_f = data_mem_Aprime{coh}(data_gender{coh}==2 & data_age{coh}>=age_cutoff);
                data_m = data_mem_Aprime{coh}(data_gender{coh}==1 & data_age{coh}>=age_cutoff);
        end                
        gender_data_tmp.mean_f = mean(data_f);
        gender_data_tmp.stdev_f = std(data_f);
        gender_data_tmp.mean_m = mean(data_m);
        gender_data_tmp.stdev_m = std(data_m);
        [H, pval, CI, STATS_tmp] = ttest2(data_f, data_m);
        % use classic t-test for T statistic (requires Statistics toolbox)
        gender_data_tmp.T = STATS_tmp.tstat;
        % use bf.ttest2 for Bayes factor (requires bf toolbox)
        gender_data_tmp.BF10 = bf.ttest2(data_m, data_f);
        gender_data{coh, ag} = gender_data_tmp;
    end
end

% Define age groups and gender labels
ageLabels = {'young', 'older'};
genderLabels = {'female', 'male'};

% Write results to a tab-separated text file
filename = 'memory_results_gender.txt';
fid = fopen(filename, 'w');

if fid == -1
    error('Error creating or opening the file for writing.');
end

fprintf(fid, '\t%s\t%s\t%s\n', 'Cohort 1', 'Cohort 2', 'Cohort 3');

for ageIdx = 1:length(ageLabels)
    fprintf(fid, '\n');
    fprintf(fid, '%s\t\t\t\n', ageLabels{ageIdx});
    fprintf(fid, 'female\t%2.2f +/- %2.2f\t%2.2f +/- %2.2f\t%2.2f +/- %2.2f\n', ...
        gender_data{1,ageIdx}.mean_f, gender_data{1,ageIdx}.stdev_f, gender_data{2,ageIdx}.mean_f, gender_data{2,ageIdx}.stdev_f, gender_data{3,ageIdx}.mean_f, gender_data{3,ageIdx}.stdev_f);
    fprintf(fid, 'male\t%2.2f +/- %2.2f\t%2.2f +/- %2.2f\t%2.2f +/- %2.2f\n', ...
        gender_data{1,ageIdx}.mean_m, gender_data{1,ageIdx}.stdev_m, gender_data{2,ageIdx}.mean_m, gender_data{2,ageIdx}.stdev_m, gender_data{3,ageIdx}.mean_m, gender_data{3,ageIdx}.stdev_m);
    fprintf(fid, '\n');
    fprintf(fid, 'T\t%2.2f\t%2.2f\t%2.2f\n', gender_data{1,ageIdx}.T, gender_data{2,ageIdx}.T, gender_data{3,ageIdx}.T);
    fprintf(fid, 'BF10\t%2.3f\t%2.3f\t%2.3f\n', gender_data{1,ageIdx}.BF10, gender_data{2,ageIdx}.BF10, gender_data{3,ageIdx}.BF10);
end

fclose(fid);
disp(['Results written to ' filename]);
