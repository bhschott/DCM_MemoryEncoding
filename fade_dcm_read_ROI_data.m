function ROI_stats = fade_dcm_read_ROI_data(scanner_name)
% This function reads ROI data for subjects scanned on a specific scanner and
% computes basic statistics for each ROI, including the mean and standard deviation
% of the ROI's x, y, and z coordinates and the number of voxels in the ROI.
%
% Inputs:
% - scanner_name: a string specifying the scanner used to acquire the data.
%                 Must be either 'verio' or 'skyra'.
%
% Outputs:
% - ROI_stats: a struct array containing the computed statistics for each ROI.
%              Each element of the array corresponds to a different ROI.
%              The fields of the struct include:
%              - name: a string containing the name of the ROI.
%              - age: an array of ages for each subject in the study.
%              - xyz_mean: a 3xN array containing the mean x, y, and z
%                          coordinates of the ROI across all subjects.
%              - xyz_std: a 3xN array containing the standard deviation of
%                         the x, y, and z coordinates of the ROI across all subjects.
%              - nvoxels: an array containing the number of voxels in the ROI
%                         for each subject in the study.

% written by Björn Schott 02/2023

% Define paths to data directories and tools
vol_name = 'ArmorATD';
project_dir = strcat('/Volumes/', vol_name, '/projects/FADE_2016/');
tools_dir = strcat(project_dir, 'tools_BS/');
dcm_tools_dir = strcat(tools_dir, 'DCM_tools/');
dir_dcm = 'DCM_main/';
dir_level1 = strcat(dir_dcm, 'GLM3_4dcm_2021_s6/');

% Check if scanner_name was provided
if nargin < 1
    disp('Please provide scanner name.')
    return
end

% Load subject information from file
if strcmp(scanner_name, 'verio')
    subj_filename = 'subjects_verio_2022-04-22.txt';
elseif strcmp(scanner_name, 'skyra')
    subj_filename = 'subjects_skyra-all_2022-04-22.txt';
else
    disp('Unknown scanner name.')
    return
end

subj_file = strcat(tools_dir, subj_filename);
[scanner, subj_ids, age, sex, age_groups, age_group3, AiA, young, old, male, female, verio, skyra] = textread(subj_file, '%d%s%d%d%d%d%d%d%d%d%d%d%d', 'delimiter', '\t', 'headerlines', 1);
nsubjects = length(subj_ids);

% Define ROI names
ROI_names = {'PPA_r', 'HC_ant_r', 'PreCun_r'};
num_ROIs = length(ROI_names);

% Initialize empty arrays to hold ROI data
for ro = 1:num_ROIs
    eval(sprintf('ROIs_%s_xyz_mean = [];', ROI_names{ro}));
    eval(sprintf('ROIs_%s_xyz_std = [];', ROI_names{ro}));
    eval(sprintf('ROIs_%s_xyz_size = [];', ROI_names{ro}));
end

% Loop over all subjects and extract ROI data
for subj = 1:length(subj_ids)
    subj_id = subj_ids{subj};
    
    % Determine which scanner was used for this subject
    sc = scanner(subj);
    switch sc
        case 1
            scanner_name = 'verio';
        case 2
            scanner_name = 'skyra';
        case 3
            scanner_name = 'skrep';
    end
    
    % Build paths to subject directory and data directory
    subj_dir = strcat(project_dir, 'subjects_', scanner_name, '/', subj_id, '/');
    data_dir = strcat(subj_dir, dir_level1);

    % Loop over all ROIs and load VOI data
    for ro = 1:num_ROIs
        % Load VOI data for this ROI
        load(strcat(data_dir, 'VOI_', ROI_names{ro}, '_1.mat'))
        
        % Calculate mean and standard deviation of ROI coordinates
        ROI_size = length(xY.XYZmm(1,:));
        if ROI_size > 1
            meanXYZ = mean(xY.XYZmm')';
            stdXYZ = std(xY.XYZmm')';
        else
            meanXYZ = xY.XYZmm;
            stdXYZ = [0;0;0];
        end
        
        % Store mean, standard deviation, and size of ROI coordinates
        eval(sprintf('ROIs_%s_xyz_mean = [ROIs_%s_xyz_mean meanXYZ];', ROI_names{ro}, ROI_names{ro}));
        eval(sprintf('ROIs_%s_xyz_std = [ROIs_%s_xyz_std stdXYZ];', ROI_names{ro}, ROI_names{ro}));
        eval(sprintf('ROIs_%s_xyz_size = [ROIs_%s_xyz_size ROI_size];', ROI_names{ro}, ROI_names{ro}));
    end   
end

% Create struct to store ROI statistics
for ro = 1:num_ROIs
    ROI_stats(ro).name = ROI_names{ro};
    ROI_stats(ro).age = age;
    eval(sprintf('ROI_stats(ro).xyz_mean = ROIs_%s_xyz_mean;', ROI_names{ro}));
    eval(sprintf('ROI_stats(ro).xyz_std = ROIs_%s_xyz_std;', ROI_names{ro}));
    eval(sprintf('ROI_stats(ro).nvoxels = ROIs_%s_xyz_size;', ROI_names{ro}));
end



