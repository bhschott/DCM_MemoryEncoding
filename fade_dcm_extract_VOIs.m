function fade_dcm_extract_VOIs(subj_filename)

% extracts ROIs for hippocampus, PPA, precuneus, and mPFC (mPFC not used in final model)

% name of the 1st level directory within subject directory
dir_dcm = 'DCM_main/';
dir_level1 = strcat(dir_dcm, 'GLM3_4dcm_2021_s6/');

% for external harddrives in Unix-based systems ... needs to be adapted for windows
vol_name = 'ArmorATD';
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE_2016/');
tools_dir = strcat(project_dir, 'tools_BS/');
analyses_dir = strcat(project_dir, 'analyses/2nd_level/');
num_vois_full = 4;

try
    cd(analyses_dir)
catch
    mkdir(analyses_dir)
    cd(analyses_dir)
end

if nargin < 1
    subj_filename = 'subjects_all_2020_11_05.txt';
end
subj_file = strcat(tools_dir, subj_filename);

[scanner subj_ids age sex age_groups age_group3 AiA young old male female verio skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);

for subj = 1:length(subj_ids)
    
    subj_id = subj_ids{subj};
    switch scanner(subj)
        case 1
            scanner_name = 'verio';
        case 2
            scanner_name = 'skyra';
        case 3
            scanner_name = 'skrep';
    end
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

