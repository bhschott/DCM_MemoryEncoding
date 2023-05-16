% This script extracts explained variances from all three cohorts and all 
% slice timing options (TR/nslices, TR/2, TR), and compares them within and
% across cohorts. 
%
% written by Björn Schott 13.06.2022

n_cohorts = 3; % Define the number of cohorts
n_st_options = 3; % Define the number of slice timing options
exp_var = cell(n_cohorts,n_st_options); % Initialize a cell array to store explained variances

% Define the working directory and subdirectories where the data files are stored
work_dir = '/Volumes/MYDRIVE/projects/FADE/analyses_new/DCM/'; 
st_dirs = {'DCM_firstresponder_2022-06-10'; 'DCM_firstresponder_2022-06-09'; 'DCM_firstresponder_2022-05-07'};
st_dir_suffs = {'_zeroTR'; '_halfTR'; ''};
co_dir_suffs = {'_yFADE_3regions'; '_verio_3regions'; '_skyra_3regions'};

% Loop through each slice timing option and cohort
for st = 1:n_st_options
    for co = 1:n_cohorts
        % Define the current directory and file name for the current slice 
        % timing option and cohort
        current_dirname = strcat(work_dir, st_dirs{st}, '/DCM_emppriors', st_dir_suffs{st}, co_dir_suffs{co}, '/');
        current_gcm_name = strcat('GCM_full', st_dir_suffs{st});
        current_gcm_file = strcat(current_dirname, current_gcm_name, '.mat');
        
        % Extract the explained variance from the current file and store it
        % in the cell array
        exp_var{st,co} = fade_dcm_extract_vexp(current_gcm_file);
    end
end

stats_list = []; % Initialize a list to store the statistical test results

st_suffs = {'zeroTR'; 'halfTR'; 'fullTR'}; % Define suffixes for slice timing options
co_suffs = {'yFADE'; 'verio'; 'skyra'}; % Define suffixes for cohorts

cmp1 = [1 1 2]; % Define the first comparison group
cmp2 = [2 3 3]; % Define the second comparison group

% Loop through each slice timing option and cohort again
for st = 1:n_st_options
    for co = 1:n_cohorts
        % Perform a t-test between the two comparison groups
        [h p ci stats] = ttest(exp_var{cmp1(st),co},exp_var{cmp2(st),co});
        
        % Calculate the Bayes factor for the t-test
        [bfac pb] = bf.ttest(exp_var{cmp1(st),co},exp_var{cmp2(st),co});   
        
        % Store the statistical test results in a structure and append it
        % to the list of results
        current_stat.title = strcat(co_suffs{co}, '_', st_suffs{cmp1(st)}, '_', st_suffs{cmp2(st)});
        current_stat.T = stats.tstat;
        current_stat.p = p;
        current_stat.pb = pb;
        current_stat.bf = bfac;
        stats_list = [stats_list current_stat];
    end
end
