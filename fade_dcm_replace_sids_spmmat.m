function fade_dcm_replace_sids_spmmat(cohort, spmfile)
% replace subject IDs / file paths in SPM.mat files 

tools_dir = '/Users/bschott/ownCloud/FADE/analyses_BS/tools_BS/DCM_tools/';

if nargin < 1
    disp('Must specify cohort.')
    return
end

% load SPM.mat with IDs to be replaced
if nargin < 2
    [spmfile, sts] = spm_select(1,'^SPM\.mat$','Select SPM.mat');
    if ~sts, return; end
    swd = spm_file(spmfile,'fpath');
    load(fullfile(swd,'SPM.mat'))
else
    [swd dummy1 dummy2] = fileparts(spmfile);
    load(spmfile)
end
    

cohort_names = {'yfade', 'verio', 'skyra'};
subj_filename = strcat('subjects_', cohort_names{cohort}, '_new-ids.txt');
subj_file = strcat(tools_dir, subj_filename)

% load tab-separated textfile with old and new IDs

switch cohort
    case 1    
        [old_ids DZNE_ids mbm gender sex age scanner AiA_yFADE AiA young old male female verio skyra new_ids] = textread(subj_file, '%s%s%s%s%d%f%d%d%d%d%d%d%d%d%d%s', 'delimiter', '\t', 'headerlines', 1);        
    case {2, 3}   
        [scanner old_ids age sex age_groups age_group3 AiA young old male female verio skyra new_ids] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d%s', 'delimiter', '\t', 'headerlines', 1);
end

% get number of subjects from SPM
n_subjects = SPM.nscan;

% Create a mapping between old IDs and new IDs
id_mapping = containers.Map(old_ids, new_ids);

% Loop through file paths and replace old IDs with new IDs
for subj = 1:n_subjects
    file_path = SPM.xY.VY(subj).fname;
    for subjj = 1:n_subjects
        old_id = old_ids{subjj};
        if contains(file_path, old_id)
            new_id = id_mapping(old_id);
            new_file_path = strrep(file_path, old_id, new_id);
            new_file_path = strrep(new_file_path, 'ArmorATD', 'MYDRIVE');
            new_file_path = strrep(new_file_path, 'DCM_main/GLM3_4dcm_2021_s6', 'GLM_parametric');
            break; % Found a match, no need to continue searching
        end
    end
    SPM.xY.VY(subj).fname = new_file_path;
    SPM.xY.VY(subj).private.dat.fname = new_file_path;
    SPM.xY.P{subj} = new_file_path;
end


% save SPM.mat with updated filenames
save(fullfile(swd, 'SPM.mat'), 'SPM');
