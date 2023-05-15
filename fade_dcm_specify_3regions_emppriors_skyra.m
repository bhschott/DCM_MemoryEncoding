% This script specifies and estimates a dynamic causal model (DCM) for fMRI
% data using SPM12, based on the DCM PEB tutorial by Peter Zeidman et al. 
% (2019). 
%
% written by Björn Schott 04/2022

% Define the name of the DCM (this will be used in the output directory)
GCM_name = 'emppriors_cohort3';

% Define the MRI scanner settings (TR and TE)
TR = 2.58;   % Repetition time (secs)
TE = 0.03;   % Echo time (secs)

% Define the directory settings
% Specify the name of the 1st level directory within subject directory
dir_dcm = 'DCM_main/';
dir_level1 = strcat(dir_dcm, 'GLM3_4dcm_2021_s6/');

% Specify the name of the external hard drive (for Unix-based systems)
vol_name = 'ZOMBIE';
% Specify the project directory (including the tools and DCM tools directories)
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE_2016/');
tools_dir = strcat(project_dir, 'tools_BS/');
dcm_tools_dir = strcat(tools_dir, 'DCM_tools/');

% Read the subject list from a text file
subj_filename = 'subjects_skyra-all_2022-04-22.txt';
subj_file = strcat(tools_dir, subj_filename);
[scanner subj_ids age sex age_groups age_group3 AiA young old male female verio skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);
nsubjects = length(subj_ids);

% Define the index of each condition in the DCM
nconditions = 2;
NOV=1; DM=2; MASTER=3; % master not used here

% Define the name and index of each region in the DCM
nregions = 3; 
VOI_names = {'PPA_r' 'HC_ant_r' 'PreCun_r' 'rACC_r'}; % rACC not used here
PPA_r = 1; HC_ant_r = 2; PreCun_r = 3; rACC_r = 4;
for voi = 1:nregions
    eval(sprintf('%s = %d;', VOI_names{voi}, voi)); % dynamically define variables based on VOI_names
end

% Prepare the output directory
out_dir = strcat(project_dir, 'analyses_new/DCM/DCM_', GCM_name, '_', num2str(nregions), 'regions/');
if ~exist(out_dir,'file')
    mkdir(out_dir);
end

% Specify the A-matrix (on/off connectivity)
a = ones(nregions,nregions); % assume full intrinsic connectivity (except rACC-PPA)

% Specify the B-matrix (connectivity modulation by each condition)
b(:,:,NOV)     = zeros(nregions); % novelty (only driving input)
b(:,:,DM)      = not(eye(nregions));   % DM cam modulate all connections
% b(:,:,MASTER)  = eye(nregions);   % master image, not used here

% C-matrix
c = zeros(nregions,nconditions);
c(PPA_r,NOV) = 1;   % assume novelty as driving input to PPA

% D-matrix (disabled)
d = zeros(nregions,nregions,0);

% main loop starts here
start_dir = pwd;
for subj = 1:nsubjects
    
    % set directories
    subj_id = subj_ids{subj};
    sc = scanner(subj);
    switch sc
        case 1
            scanner_name = 'verio';
        case 2
            scanner_name = 'skyra';
        case 3
            scanner_name = 'skrep';
    end
    subj_dir = strcat(project_dir, 'subjects_', scanner_name, '/', subj_id, '/')
    glm_dir = strcat(subj_dir, dir_level1);
    subj_spm_mat = strcat(glm_dir, 'SPM.mat');
    
    % Load SPM
    SPM     = load(fullfile(glm_dir,'SPM.mat'));
    SPM     = SPM.SPM;
    
    % Load VOIs
    for r = 1:nregions
        filename = strcat('VOI_', VOI_names{r}, '_1.mat');
        f{r} = fullfile(glm_dir, filename);
        XY = load(f{r});
        xY(r) = XY.xY;
    end
    
    % Move to output directory
    cd(glm_dir);
    
    % Select whether to include each condition from the design matrix
    % (NOV, DM, MASTER)
    include = [1 1; 0 0];    
    
    % Specify. Corresponds to the series of questions in the GUI.
    s = struct();
    s.name       = 'full';
    s.u          = include;                 % Conditions
    s.delays     = repmat(TR,1,nregions);   % Slice timing for each region
    s.TE         = TE;
    s.nonlinear  = false;
    s.two_state  = false;
    s.stochastic = false;
    s.centre     = true;
    s.induced    = 0;
    s.a          = a;
    s.b          = b;
    s.c          = c;
    s.d          = d;
    DCM = spm_dcm_specify(SPM,xY,s);
    
    % Return to script directory
    cd(start_dir);
end

% Collate into a GCM file and estimate

% original script: Find all DCM files
% here: use DCMs from subjects in list only
% original code: dcms = spm_select('FPListRec','../GLM','DCM_full.mat');
% spm_select does not work well here, replaced
% searchstr = strcat(project_dir, 'subjects_*/*/DCM_main/GLM3_4dcm_2021_s6/DCM_full.mat');
% tmp = dir(searchstr); 
dcm_list = {};
for subj = 1:nsubjects
    % dcm_list = [dcm_list; fullfile(tmp(subj).folder, tmp(subj).name)];
    switch scanner(subj)
        case 1
            scanner_name = 'verio';
        case 2
            scanner_name = 'skyra';
        case 3
            scanner_name = 'skrep';
    end
    subj_id = subj_ids{subj};
    dcm_list = [dcm_list; strcat(project_dir, 'subjects_', scanner_name, '/', subj_id, '/', dir_level1, 'DCM_full.mat')];
end

% Check if it exists
if exist(fullfile(out_dir,'GCM_full.mat'),'file')
    opts.Default = 'No';
    opts.Interpreter = 'none';
    f = questdlg('Overwrite existing GCM?','Overwrite?','Yes','No',opts);
    tf = strcmp(f,'Yes');
else
    tf = true;
end

% Collate & estimate
if tf
    % Character array -> cell array
    % GCM = cellstr(dcms); 
    % in this script, it is already a cell array, so skip this step
    
    % Filenames -> DCM structures
    GCM = spm_dcm_load(dcm_list);

    % Estimate DCMs (this won't effect original DCM files)
    % GCM = spm_dcm_fit(GCM);
    % use empirical priors
    GCM = spm_dcm_peb_fit(GCM);
    % Save estimated GCM
    save(strcat(out_dir, 'GCM_full.mat'),'GCM');
end

% Specify alternative models structures
% These will be templates for the group analysis

% Define B-matrix for each family (precuneus connectivity defines family)
% -------------------------------------------------------------------------
b_prec_fam = {};

% no modulation of precuneus connections
b_prec_fam{1}(:,:) = not(eye(nregions)); % DM
% set precuneus connections to 0
b_prec_fam{1}(3,:) = 0;
b_prec_fam{1}(:,3) = 0;

% modulation of precuneus-PPA connection
b_prec_fam{2}(:,:) = not(eye(nregions)); % DM
% set precuneus-HC connections to 0
b_prec_fam{2}(3,2) = 0;
b_prec_fam{2}(2,3) = 0;

% modulation of precuneus-HC connection
b_prec_fam{3}(:,:) = not(eye(nregions)); % DM
% set precuneus-PPA connections to 0
b_prec_fam{3}(3,1) = 0;
b_prec_fam{3}(1,3) = 0;

% modulation of precuneus connection with both PPA and HC
b_prec_fam{4}(:,:) = not(eye(nregions)); % DM

prec_fam_names = {'Prec-none','Prec-PPA','Prec-HC', 'Prec-both'};

% Define B-matrix for each sub-family (factor: PPA-HC connectivity)
% -------------------------------------------------------------------------
b_ph_fam = {};
% none
b_ph_fam{1}(:,:) = not(eye(nregions));
b_ph_fam{1}(1,2) = 0;
b_ph_fam{1}(2,1) = 0;

% HC->PPA
b_ph_fam{2}(:,:) = not(eye(nregions));
b_ph_fam{2}(2,1) = 0;

% PPA->HC   
b_ph_fam{3} = not(eye(nregions));
b_ph_fam{3}(1,2) = 0;

% both
b_ph_fam{4}(:,:) = not(eye(nregions));

ph_fam_names = {'none','HC-PPA', 'PPA-HC', 'both'};
           
           
% Make a DCM for each mixture of these factors
% -------------------------------------------------------------------------

% Load and unpack an example DCM
GCM_full = load(strcat(out_dir, 'GCM_full.mat'));
GCM_full = spm_dcm_load(GCM_full.GCM);
DCM_template = GCM_full{1,1};
a = DCM_template.a;
c = DCM_template.c;
d = DCM_template.d;
options = DCM_template.options;

% Output cell array for new models
GCM_templates = {};

m = 1;
for prc = 1:length(b_prec_fam)
    for ph = 1:length(b_ph_fam)
        
        % Prepare B-matrix
        b = zeros(nregions,nregions,nconditions);
        b(:,:,2) = b_prec_fam{prc} & b_ph_fam{ph};
        
        % Prepare model name
        name = sprintf('%s_%s ', prec_fam_names{prc}, ph_fam_names{ph});
        
        % Build minimal DCM
        DCM = struct();
        DCM.a       = a;
        DCM.b       = b;
        DCM.c       = c;
        DCM.d       = d;
        DCM.options = options;
        DCM.name    = name;
        GCM_templates{1,m} = DCM;
        
        % Record the assignment of this model to each family
        prec_family(m) = prc;
        ph_family(m) = ph;
        m = m + 1;
        
    end
end


% Add a null model with no modulation
%
% removed this part, null model should be the first model defined in the
% loop (please check)
%
% -------------------------------------------------------------------------
% b = zeros(nregions);
% c = zeros(nregions,nconditions);
% c(PPA,NOV) = 1;   % assume novelty as driving input to PPA
% name = 'Task: None';
% DCM.b(:,:,2) = b;
% DCM.b(:,:,3) = b;
% DCM.c        = c;
% DCM.name     = name;
% GCM_templates{1,m} = DCM;

% Record the assignment of this model to each family
% b_dv_family(m) = length(b_dv_fam)+1;
% b_lr_family(m) = length(b_lr_fam)+1;
% task_family(m) = length(b_task_fam)+1;

% m = m + 1;    

% Save
GCM = GCM_templates;
save(strcat(out_dir, 'GCM_templates.mat'),'GCM', 'prec_family','ph_family');

% Run diagnostics
load(strcat(out_dir, 'GCM_full.mat'));
spm_dcm_fmri_check(GCM);