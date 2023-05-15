% fade_dcm_prepare_data4upload.m
% anonymize GCM file by replacing subject IDs with random IDs
% 
% written by Björn Schott 05/2023

% to be adjusted for each cohort
cohort_dir = 'DCM_emppriors_cohort3_3regions';
subjects_dir = '/Volumes/ArmorATD/projects/FADE_2016/subjects_verio/';
new_sids_filename = 'new_subj_ids_cohort3.txt';
new_subjects_dir = '/Volume/MYDRIVE/fmri_data/FADE/subjects_cohort3/';

% same for all cohorts
study_dir = '/Users/bschott/ownCloud/FADE/analyses_BS/DCM/';
work_dir = strcat(study_dir, 'DCM_firstresponder_2022-05-07/');
GCM_dir = strcat(work_dir, cohort_dir, '/');
dest_dir = strcat(GCM_dir, 'data/');
mkdir(dest_dir)

% rename VOI source directories 
cwd = pwd;
cd(GCM_dir);
load GCM_full.mat
num_subjs = length(GCM);
new_subj_ids = textread(new_sids_filename, '%s', 'delimiter', '\n');

for subj = 1 num_subjs
    num_rois = length(GCM{subj}.xY);
    for roi = 1:num_rois
        old_filename = GCM{subj}.xY(roi).spec.fname;
        old_subj_id = old_filename(length(subjects_dir)+1:length(subjects_dir)+4);
        new_subj_id = new_subj_ids{subj};
        [fp nam ext] = fileparts(old_filename);
        new_filename = strcat(new_subjects_dir, new_subj_id, '/GLM_parametric/', nam, ext);
        GCM{subj}.xY(roi).spec.fname = new_filename;
        GCM{subj}.xY(roi).spec.private.dat.fname = new_filename;
    end
end

cd(dest_dir)
save('GCM_full.mat', 'GCM');

cd(cwd)

