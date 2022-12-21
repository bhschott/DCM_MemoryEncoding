% extract DCM parameters for SVM regression (or other analyses)

% directories & filenames
vol_name = 'ArmorATD';
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE_2016/');
tools_dir = strcat(project_dir, 'tools_BS/');

work_dir = strcat(project_dir, 'analyses_new/DCM/DCM_outlander_04-2022/');
dcm_dir = strcat(work_dir, 'DCM_emppriors_skyra_3regions/');
dcm_results_file = strcat(dcm_dir, 'GCM_full.mat');

subj_filename = 'subjects_skyra-all_2022-04-22.txt';
subj_file = strcat(tools_dir, subj_filename);

load(dcm_results_file);

% read DCM parameters for each subject

param_list = [];
for subj = 1:length(GCM)
    
    % read A-matrix and B-matrix
    A_matrix = GCM{subj}.Ep.A;
    B_matrix = GCM{subj}.Ep.B(:,:,2); % adapt for other DCMs
    n_regions = length(A_matrix);
    ma = 0; mb = 0; A_params = []; B_params = []; 
    for from_reg = 1:n_regions
        for to_reg = 1:n_regions
            ma = ma + 1;
            A_params(ma) = A_matrix(to_reg, from_reg);
            if to_reg ~= from_reg % ignore self-connectivity in B-matrix
                mb = mb+1;
                B_params(mb) = B_matrix(to_reg, from_reg);
            end
        end
    end
    params = [A_params B_params];
    param_list = [param_list; params];
            
end

[scanner subj_ids age sex age_groups age_group3 AiA young old male female verio skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);

mean(param_list)
[H,P,CI,STATS] = ttest(param_list)

plist_y = param_list(age_groups==1,:);
plist_o = param_list(age_groups==2,:);

mean(plist_y)
mean(plist_o)
[H,P,CI,STATS] = ttest2(plist_y, plist_o)