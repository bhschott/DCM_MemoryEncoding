function fade_dcm_extract_VOIs(subj_filename)
% This function extracts ROIs for the hippocampus, PPA, precuneus, and mPFC (mPFC is not used in the final model).
% It takes a subject file as input (subj_filename) and defines VOI jobs for each subject in the file.
%
% written by Björn Schott 02/2021

% Define the name of the 1st level directory within the subject directory.
dir_dcm = 'DCM_main/';
dir_level1 = strcat(dir_dcm, 'GLM3_4dcm_2021_s6/');

% Define directories for accessing data on external hard drives in Unix-based systems.
vol_name = 'ArmorATD';
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE_2016/');
tools_dir = strcat(project_dir, 'tools_BS/');
analyses_dir = strcat(project_dir, 'analyses/2nd_level/');
num_vois_full = 4;

% Create the analyses directory if it does not already exist.
try
    cd(analyses_dir)
catch
    mkdir(analyses_dir)
    cd(analyses_dir)
end

% If no subject file is specified, use the default file.
if nargin < 1
    subj_filename = 'subjects_all_2020_11_05.txt';
end

% Load subject data from the file.
subj_file = strcat(tools_dir, subj_filename);
[scanner subj_ids age sex age_groups age_group3 AiA young old male female verio skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);

% Loop through each subject in the file.
for subj = 1:length(subj_ids)
    
    subj_id = subj_ids{subj};
    % Identify the scanner used for this subject.
    switch scanner(subj)
        case 1
            scanner_name = 'verio';
        case 2
            scanner_name = 'skyra';
        case 3
            scanner_name = 'skrep';
    end
    % Define the directory for this subject.
    subj_dir = strcat(project_dir, 'subjects_', scanner_name, '/', subj_id, '/');
    level1_dir = strcat(subj_dir, dir_level1);
    subj_spm_mat = strcat(level1_dir, 'SPM.mat');
    disp(['Defining job for subject ', subj_id]);
    
    % anterior hippocampus (right)
    matlabbatch{1}.spm.util.voi.spmmat = {subj_spm_mat};
    matlabbatch{1}.spm.util.voi.adjust = 1;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'HC_ant_r';
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [21 -10 -19];
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 15;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.spmmat = {strcat(analyses_dir, 'old-young_mem/SPM.mat')};
    matlabbatch{1}.spm.util.voi.roi{2}.spm.contrast = 3;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.conjunction = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
    matlabbatch{1}.spm.util.voi.roi{2}.spm.thresh = 0.001;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.extent = 10;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{1}.spm.util.voi.roi{3}.mask.image = {strcat('/Volumes/', vol_name, '/projects/FADE_2016/analyses_new/ROIs/hippo_AAL_right.nii,1')};
    matlabbatch{1}.spm.util.voi.roi{3}.mask.threshold = 0.5;
    matlabbatch{1}.spm.util.voi.roi{4}.spm.spmmat = {subj_spm_mat};
    matlabbatch{1}.spm.util.voi.roi{4}.spm.contrast = 1;
    matlabbatch{1}.spm.util.voi.roi{4}.spm.conjunction = 1;
    matlabbatch{1}.spm.util.voi.roi{4}.spm.threshdesc = 'none';
    matlabbatch{1}.spm.util.voi.roi{4}.spm.thresh = 0.25;
    matlabbatch{1}.spm.util.voi.roi{4}.spm.extent = 0;
    matlabbatch{1}.spm.util.voi.roi{4}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{1}.spm.util.voi.expression = 'i1&i2&i3&i4';
    
    % PPA (right)
    matlabbatch{2}.spm.util.voi.spmmat = {subj_spm_mat};
    matlabbatch{2}.spm.util.voi.adjust = 1;
    matlabbatch{2}.spm.util.voi.session = 1;
    matlabbatch{2}.spm.util.voi.name = 'PPA_r';
    matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {strcat(analyses_dir, 'old-young_nov/SPM.mat')};
    matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 3;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.001;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 10;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{2}.spm.util.voi.roi{2}.mask.image = {strcat('/Volumes/', vol_name, '/projects/FADE_2016/analyses_new/ROIs/mask_MNI_tresh_2sd_gmr_p0.5_rPPA.nii,1')};
    matlabbatch{2}.spm.util.voi.roi{2}.mask.threshold = 0.5;
    matlabbatch{2}.spm.util.voi.roi{3}.mask.image = {strcat('/Volumes/', vol_name, '/projects/FADE_2016/analyses_new/ROIs/FFG_PHC_AAL.nii,1')};
    matlabbatch{2}.spm.util.voi.roi{3}.mask.threshold = 0.5;
    matlabbatch{2}.spm.util.voi.roi{4}.spm.spmmat = {subj_spm_mat};
    matlabbatch{2}.spm.util.voi.roi{4}.spm.contrast = 1;
    matlabbatch{2}.spm.util.voi.roi{4}.spm.conjunction = 1;
    matlabbatch{2}.spm.util.voi.roi{4}.spm.threshdesc = 'none';
    matlabbatch{2}.spm.util.voi.roi{4}.spm.thresh = 0.25;
    matlabbatch{2}.spm.util.voi.roi{4}.spm.extent = 0;
    matlabbatch{2}.spm.util.voi.roi{4}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{2}.spm.util.voi.expression = 'i1&i2&i3&i4';
    
    % precuneus (right)
    matlabbatch{3}.spm.util.voi.spmmat = {subj_spm_mat};
    matlabbatch{3}.spm.util.voi.adjust = 1;
    matlabbatch{3}.spm.util.voi.session = 1;
    matlabbatch{3}.spm.util.voi.name = 'PreCun_r';
    matlabbatch{3}.spm.util.voi.roi{1}.sphere.centre = [6 -64 38];
    matlabbatch{3}.spm.util.voi.roi{1}.sphere.radius = 18;
    matlabbatch{3}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{3}.spm.util.voi.roi{2}.spm.spmmat = {strcat(analyses_dir, 'old-young_mem/SPM.mat')};
    matlabbatch{3}.spm.util.voi.roi{2}.spm.contrast = 5;
    matlabbatch{3}.spm.util.voi.roi{2}.spm.conjunction = 1;
    matlabbatch{3}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
    matlabbatch{3}.spm.util.voi.roi{2}.spm.thresh = 0.001;
    matlabbatch{3}.spm.util.voi.roi{2}.spm.extent = 10;
    matlabbatch{3}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{3}.spm.util.voi.roi{3}.mask.image = {strcat('/Volumes/', vol_name, '/projects/FADE_2016/analyses_new/ROIs/precun_AAL_right.nii,1')};
    matlabbatch{3}.spm.util.voi.roi{3}.mask.threshold = 0.5;
    matlabbatch{3}.spm.util.voi.roi{4}.spm.spmmat = {subj_spm_mat};
    matlabbatch{3}.spm.util.voi.roi{4}.spm.contrast = 1;
    matlabbatch{3}.spm.util.voi.roi{4}.spm.conjunction = 1;
    matlabbatch{3}.spm.util.voi.roi{4}.spm.threshdesc = 'none';
    matlabbatch{3}.spm.util.voi.roi{4}.spm.thresh = 0.25;
    matlabbatch{3}.spm.util.voi.roi{4}.spm.extent = 0;
    matlabbatch{3}.spm.util.voi.roi{4}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{3}.spm.util.voi.expression = 'i1&i2&i3&i4';
    
    % rostral ACC / mPFC (right)
    matlabbatch{4}.spm.util.voi.spmmat = {subj_spm_mat};
    matlabbatch{4}.spm.util.voi.adjust = 1;
    matlabbatch{4}.spm.util.voi.session = 1;
    matlabbatch{4}.spm.util.voi.name = 'rACC_r';
    matlabbatch{4}.spm.util.voi.roi{1}.sphere.centre = [9 32 -1];
    matlabbatch{4}.spm.util.voi.roi{1}.sphere.radius = 15;
    matlabbatch{4}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{4}.spm.util.voi.roi{2}.spm.spmmat = {strcat(analyses_dir, 'old-young_mem/SPM.mat')};
    matlabbatch{4}.spm.util.voi.roi{2}.spm.contrast = 5;
    matlabbatch{4}.spm.util.voi.roi{2}.spm.conjunction = 1;
    matlabbatch{4}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
    matlabbatch{4}.spm.util.voi.roi{2}.spm.thresh = 0.001;
    matlabbatch{4}.spm.util.voi.roi{2}.spm.extent = 10;
    matlabbatch{4}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{4}.spm.util.voi.roi{3}.mask.image = {strcat('/Volumes/', vol_name, '/projects/FADE_2016/analyses_new/ROIs/ACC_AAL_right.nii,1')};
    matlabbatch{4}.spm.util.voi.roi{3}.mask.threshold = 0.5;
    matlabbatch{4}.spm.util.voi.roi{4}.spm.spmmat = {subj_spm_mat};
    matlabbatch{4}.spm.util.voi.roi{4}.spm.contrast = 1;
    matlabbatch{4}.spm.util.voi.roi{4}.spm.conjunction = 1;
    matlabbatch{4}.spm.util.voi.roi{4}.spm.threshdesc = 'none';
    matlabbatch{4}.spm.util.voi.roi{4}.spm.thresh = 0.25;
    matlabbatch{4}.spm.util.voi.roi{4}.spm.extent = 0;
    matlabbatch{4}.spm.util.voi.roi{4}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{4}.spm.util.voi.expression = 'i1&i2&i3&i4';
    
    job_name = strcat(subj_dir, dir_dcm, 'VOI_extract_', subj_id, '.mat');
    save(job_name, 'matlabbatch');
end

err_subs = {}; incompl_subs = {};
for subj = 1:length(subj_ids)
    
    subj_id = subj_ids{subj};
    switch scanner(subj)
        case 1
            scanner_name = 'verio';
        case 2
            scanner_name = 'skyra';
    end
    subj_dir = strcat(project_dir, 'subjects_', scanner_name, '/', subj_id, '/');
    subj_spm_mat = strcat(level1_dir, 'SPM.mat');
    disp(['Running job for subject ', subj_id]);
    job_name = strcat(subj_dir, dir_dcm, 'VOI_extract_', subj_id, '.mat');
    try
        spm_jobman('run', job_name);
        subj_dir = strcat(project_dir, 'subjects_', scanner_name, '/', subj_id, '/');
        level1_dir = strcat(subj_dir, dir_level1);
        cd(level1_dir)
        num_vois_actual = length(dir('VOI*.mat'));
        if num_vois_actual < num_vois_full
            incompl_subs = [incompl_subs subj_id];
        end
    catch
        err_subs = [err_subs subj_id];
        disp(['error in job ' job_name])
    end
end

err_subs
incompl_subs

