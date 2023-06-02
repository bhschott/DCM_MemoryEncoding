% read behavioral data from WMS and VLMT and compute correlations with DCM
% parameters
%
% written by Björn Schott 05/2023

% Part 1: read VLMT and WMS data from single data file
% can be skipped when loading data from data_vlmt and data_wms

work_dir = '/Users/bschott/ownCloud/FADE/analyses_BS/DCM/behavior/';

subject_datafile = strcat(work_dir, 'subject_data_old_IDs.mat');
load(subject_datafile);
num_cohorts = length(data_DCM_ABC);

vlmt_wms_datafile = strcat(work_dir, 'FADE_VLMT_WMS.txt');
[mbm_ID, MRI_ID, new_DCM, sex, age, isyFADE, VLMT_1to5, VLMT_Distractor, VLMT_5min, VLMT_30min, VLMT_1d, WMS_learn, WMS_30min, WMS_1d] = textread(vlmt_wms_datafile, '%s%s%d%d%d%d%d%d%d%d%d%f%f%f', 'delimiter', '\t', 'headerlines', 1);

% cell arrays to store VLMT and WMS data in the order given by subj_ids
data_vlmt = {};
data_wms = {};

% loop through cohorts and subjects
for coh = 1:num_cohorts
    num_subjects = length(subj_ids{coh});
    for subj = 1:num_subjects
        for subjj = 1:length(MRI_ID)
            % find correct subject ID in variable MRI_ID and use index from
            % MRI_ID for data_wms and data_vlmt below
            if strcmp(subj_ids{coh}{subj}, MRI_ID{subjj})
                % assign VLMT_1to5, VLMT_Distractor, VLMT_5min, VLMT_30min and
                % VLMT_1d to struct data_vlmt
                data_vlmt{coh}{subj}.VLMT_1to5 = VLMT_1to5(subjj);
                data_vlmt{coh}{subj}.VLMT_Distractor = VLMT_Distractor(subjj);
                data_vlmt{coh}{subj}.VLMT_5min = VLMT_5min(subjj);
                data_vlmt{coh}{subj}.VLMT_30min = VLMT_30min(subjj);
                data_vlmt{coh}{subj}.VLMT_1d = VLMT_1d(subjj);
                
                % assign WMS_learn, WMS_30min and WMS_1d to struct data_wms
                data_wms{coh}{subj}.WMS_learn = WMS_learn(subjj);
                data_wms{coh}{subj}.WMS_30min = WMS_30min(subjj);
                data_wms{coh}{subj}.WMS_1d = WMS_1d(subjj);
                
                % exit the loop since the subject has been found
                break;
            end
        end
    end
end

% Part 2: compute the actual correlation analyses

% Initialize correlation and p-value matrices
correlation_matrix = cell(num_cohorts, 1);
p_value_matrix = cell(num_cohorts, 1);

% Define VLMT & WMS fields
vlmt_fields = {'VLMT_1to5', 'VLMT_Distractor', 'VLMT_5min', 'VLMT_30min', 'VLMT_1d'};
wms_fields = {'WMS_learn', 'WMS_30min', 'WMS_1d'};

% Perform correlations for each cohort
% Initialize correlation and p-value matrices
correlation_matrix = cell(num_cohorts, 1);
p_value_matrix = cell(num_cohorts, 1);
bf10_matrix = cell(num_cohorts, 1);
n_matrix = cell(num_cohorts, 1); % actual number of data points

% number of (age) groups
n_agrps = 2;

% Perform correlations for each cohort
for coh = 1:num_cohorts
    num_subjects = size(data_DCM_ABC{coh}, 1);
    num_params = size(data_DCM_ABC{coh}, 2);
    vlmt_datapoints = length(fieldnames(data_vlmt{coh}{1}));
    wms_datapoints = length(fieldnames(data_wms{coh}{1}));
    num_behaviors = size(data_mem_Aprime{coh},2) + vlmt_datapoints + wms_datapoints;
    
    for ag = 1:n_agrps
        correlation_matrix{coh}{ag} = zeros(num_params, num_behaviors); 
        p_value_matrix{coh}{ag} = zeros(num_params, num_behaviors);
    end
    for param = 1:num_params
        % index for behavioral parameters in correlation matrix
        bhv_ind = 1;
        
        % A-prime
        %
        % Exclude NaN values from correlation calculation
        valid_indices = ~isnan(data_DCM_ABC{coh}(:, param)) & ~isnan(data_mem_Aprime{coh}(:));
        % Extract subset of data and sort by age group
        age_list = data_age{coh}(valid_indices);
        subset_a = data_DCM_ABC{coh}(valid_indices, param);
        subset_a_group{1} = subset_a(age_list<50);
        subset_a_group{2} = subset_a(age_list>=50);
        subset_b = data_mem_Aprime{coh}(valid_indices);
        subset_b_group{1} = subset_b(age_list<50);
        subset_b_group{2} = subset_b(age_list>=50);
        % Perform array-wise correlation using Shepherd_BF function
        % separately for each age group
        for ag = 1:n_agrps
            try
                [correlation BFac p_value num_ol] = Shepherd_BF(subset_a_group{ag}, subset_b_group{ag});
                num_datapoints = length(subset_a_group{ag}) - num_ol;
            catch
                correlation = NaN; p_value = 1; BFac = NaN;
            end
            % Store correlation and p-value in matrices
            correlation_matrix{coh}{ag}(param, bhv_ind) = correlation;
            p_value_matrix{coh}{ag}(param, bhv_ind) = p_value;
            bf10_matrix{coh}{ag}(param, bhv_ind) = BFac;
            n_matrix{coh}{ag}(param, bhv_ind) = num_datapoints;
        end
        
        % VLMT
        %
        % loop through data points in structure
        for vl = 1:vlmt_datapoints
            bhv_ind = bhv_ind+1;
            % generate temporary array variable to compute correlation
            data_mem_tmp = [];
            for subj=1:length(data_DCM_ABC{coh})
                data_mem_tmp = [data_mem_tmp data_vlmt{coh}{subj}.(vlmt_fields{vl})];
            end
            valid_indices = ~isnan(data_DCM_ABC{coh}(:, param)) & ~isnan(data_mem_tmp(:));
            age_list = data_age{coh}(valid_indices);
            % Extract subset of data and sort by age group
            subset_a = data_DCM_ABC{coh}(valid_indices, param);
            subset_a_group{1} = subset_a(age_list<50);
            subset_a_group{2} = subset_a(age_list>=50);
            subset_b = data_mem_tmp(valid_indices)';
            subset_b_group{1} = subset_b(age_list<50);
            subset_b_group{2} = subset_b(age_list>=50);
            % Perform array-wise correlation using Shepherd function
            % separately for each age group
            for ag = 1:n_agrps
                try
                    [correlation BFac p_value num_ol] = Shepherd_BF(subset_a_group{ag}, subset_b_group{ag});
                    num_datapoints = length(subset_a_group{ag}) - num_ol;
                catch
                    correlation = NaN; p_value = 1; BFac = NaN;
                end
                % Store correlation and p-value in matrices
                correlation_matrix{coh}{ag}(param, bhv_ind) = correlation;
                p_value_matrix{coh}{ag}(param, bhv_ind) = p_value;
                bf10_matrix{coh}{ag}(param, bhv_ind) = BFac;
                n_matrix{coh}{ag}(param, bhv_ind) = num_datapoints;
            end
        end
        
        % WMS
        %
        % loop through data points in structure
        for wm = 1:wms_datapoints
            bhv_ind = bhv_ind+1;
            % generate temporary array variable to compute correlation
            data_mem_tmp = [];
            for subj=1:length(data_DCM_ABC{coh})
                data_mem_tmp = [data_mem_tmp data_wms{coh}{subj}.(wms_fields{wm})];
            end
            valid_indices = ~isnan(data_DCM_ABC{coh}(:, param)) & ~isnan(data_mem_tmp(:));
            age_list = data_age{coh}(valid_indices);
            % Extract subset of data and sort by age group
            subset_a = data_DCM_ABC{coh}(valid_indices, param);
            subset_a_group{1} = subset_a(age_list<50);
            subset_a_group{2} = subset_a(age_list>=50);
            subset_b = data_mem_tmp(valid_indices)';
            subset_b_group{1} = subset_b(age_list<50);
            subset_b_group{2} = subset_b(age_list>=50);
            % Perform array-wise correlation using Shepherd function
            % separately for each age group
            for ag = 1:n_agrps
                try
                    [correlation BFac p_value num_ol] = Shepherd_BF(subset_a_group{ag}, subset_b_group{ag});
                    num_datapoints = length(subset_a_group{ag}) - num_ol;
                catch
                    correlation = NaN; p_value = 1; BFac = NaN;
                end
                % Store correlation and p-value in matrices
                correlation_matrix{coh}{ag}(param, bhv_ind) = correlation;
                p_value_matrix{coh}{ag}(param, bhv_ind) = p_value;
                bf10_matrix{coh}{ag}(param, bhv_ind) = BFac;
                n_matrix{coh}{ag}(param, bhv_ind) = num_datapoints;
            end            
        end
    end
end

