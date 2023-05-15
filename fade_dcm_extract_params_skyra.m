% extract DCM parameters for SVM regression (or other analyses)

% This script is used to extract DCM parameters (effective connectivity
% parameters) for each subject and store them in a matrix for use in a SVM
% regression or other analyses.

% written by Björn Schott 06/2022

% directories & filenames
vol_name = 'ArmorATD'; % name of the volume where the data is stored
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE_2016/'); % directory where the project is stored
tools_dir = strcat(project_dir, 'tools_BS/'); % directory where the tools are stored

work_dir = strcat(project_dir, 'analyses_new/DCM/DCM_outlander_04-2022/'); % directory where the DCM analysis output is stored
dcm_dir = strcat(work_dir, 'DCM_emppriors_skyra_3regions/'); % directory where the DCM results are stored
dcm_results_file = strcat(dcm_dir, 'GCM_full.mat'); % name of the file that contains the DCM results

subj_filename = 'subjects_skyra-all_2022-04-22.txt'; % name of the file that contains the subject information
subj_file = strcat(tools_dir, subj_filename); % full path to the subject information file

load(dcm_results_file); % load the DCM results

% read DCM parameters for each subject

param_list = []; % initialize a matrix to store the DCM parameters for all subjects
for subj = 1:length(GCM) % loop through each subject in the DCM results
    
    % read A-matrix and B-matrix
    A_matrix = GCM{subj}.Ep.A; % extract the A-matrix for the current subject
    B_matrix = GCM{subj}.Ep.B(:,:,2); % extract the B-matrix for the current subject (adapt for other DCMs)
    n_regions = length(A_matrix); % get the number of regions
    ma = 0; mb = 0; A_params = []; B_params = []; 
    % initialize counters and matrices to store the DCM parameters
    for from_reg = 1:n_regions
        for to_reg = 1:n_regions
            ma = ma + 1; % increment the counter for A_params
            A_params(ma) = A_matrix(to_reg, from_reg); % store the A parameter
            if to_reg ~= from_reg % ignore self-connectivity in B-matrix
                mb = mb+1; % increment the counter for B_params
                B_params(mb) = B_matrix(to_reg, from_reg); % store the B parameter
            end
        end
    end
    params = [A_params B_params]; % concatenate the A and B parameters
    param_list = [param_list; params]; % add the parameters to the parameter list
            
end

% read subject information
[scanner subj_ids age sex age_groups age_group3 AiA young old male female verio skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);

% calculate means and t-tests
mean(param_list) % calculate the mean of each DCM parameter across all subjects
[H,P,CI,STATS] = ttest(param_list) % perform a one-sample t-test on each DCM parameter across all subjects

plist_y = param_list(age_groups==1,:); % create a subset of the parameter list for young subjects
plist_o = param_list(age_groups==2,:); % create a subset of the parameter list for older subjects


