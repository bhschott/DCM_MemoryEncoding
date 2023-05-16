% batch dcm_peb 2nd level
% based on batch generated with SPM Batch Editor
% 
% written by Björn Schott 04/2022

% for external harddrives in Unix-based systems ... needs to be adapted for Windows
vol_name = 'MYDRIVE';
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE/');
tools_dir = strcat(project_dir, 'tools_BS/');
dcm_tools_dir = strcat(tools_dir, 'DCM_tools/');
dcm_data_dir = strcat(project_dir, '/analyses_new/DCM/');
dcm_model_dir = strcat(dcm_data_dir, 'DCM_emppriors_skyra_3regions/');

% read subject list
subj_filename = 'subjects_skyra-all_2022-04-22.txt';
subj_file = strcat(tools_dir, subj_filename);
[scanner subj_ids age sex age_group age_group3 AiA young old male female verio skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);
nsubjects   = length(subj_ids)

clear matlabbatch

% define batch, with covariates (if any) specified manually
matlabbatch{1}.spm.dcm.peb.specify.name = 'Memory_A_B_age-only';
matlabbatch{1}.spm.dcm.peb.specify.model_space_mat = {strcat(dcm_model_dir, 'GCM_full.mat')};
matlabbatch{1}.spm.dcm.peb.specify.dcm.index = 1;
matlabbatch{1}.spm.dcm.peb.specify.cov.regressor(1).name = 'age_group';
age_grp = age_group-1;
matlabbatch{1}.spm.dcm.peb.specify.cov.regressor(1).value = age_grp;
matlabbatch{1}.spm.dcm.peb.specify.fields.default = {
                                                     'A'
                                                     'B'
                                                     }';
matlabbatch{1}.spm.dcm.peb.specify.priors_between.components = 'All';
matlabbatch{1}.spm.dcm.peb.specify.priors_between.ratio = 16;
matlabbatch{1}.spm.dcm.peb.specify.priors_between.expectation = 0;
matlabbatch{1}.spm.dcm.peb.specify.priors_between.var = 0.0625;
matlabbatch{1}.spm.dcm.peb.specify.priors_glm.group_ratio = 1;
matlabbatch{1}.spm.dcm.peb.specify.estimation.maxit = 1024;
matlabbatch{1}.spm.dcm.peb.specify.show_review = 0;

% search nested models
matlabbatch{2}.spm.dcm.peb.reduce_all.peb_mat(1) = cfg_dep('Specify / Estimate PEB: PEB mat File(s)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','peb_mat'));
matlabbatch{2}.spm.dcm.peb.reduce_all.model_space_mat = {strcat(dcm_model_dir, 'GCM_full.mat')};
matlabbatch{2}.spm.dcm.peb.reduce_all.nullpcov = 0.0625;
matlabbatch{2}.spm.dcm.peb.reduce_all.show_review = 1;

save(strcat(dcm_data_dir, 'batch_fade_dcm_3regions_emppriors_skyra.mat'), 'matlabbatch');

job_name = strcat(dcm_data_dir, 'batch_fade_dcm_3regions_emppriors_skyra.mat');
try
    spm_jobman('run', job_name);
catch
    ers = lasterror;
    disp(['Fehler in Job ' job_name])
end
