% read ROI data and compute stats for all cohorts

roi_stats_cohort{1} = yfade_dcm_read_ROI_data;
roi_stats_cohort{2} = fade_dcm_read_ROI_data('verio');
roi_stats_cohort{3} = fade_dcm_read_ROI_data('skyra');

ROI_names = {'PPA_r' 'HC_ant_r' 'PreCun_r'};

cohort_roi = {};

for coh = 1:length(roi_stats_cohort)
    for roi = 1:length(ROI_names)
        mean_xyz_young = mean(roi_stats_cohort{coh}(roi).xyz_mean(:,roi_stats_cohort{coh}(roi).age<50)')';
        eval(sprintf('cohort_roi{coh}.ROI_%s_mean_young = mean_xyz_young;', ROI_names{roi}));
        std_xyz_young = std(roi_stats_cohort{coh}(roi).xyz_mean(:,roi_stats_cohort{coh}(roi).age<50)')';
        eval(sprintf('cohort_roi{coh}.ROI_%s_std_young = std_xyz_young;', ROI_names{roi}));
        mean_size_young = mean(roi_stats_cohort{coh}(roi).nvoxels(roi_stats_cohort{coh}(roi).age<50));
        eval(sprintf('cohort_roi{coh}.ROI_%s_size_young = mean_size_young;', ROI_names{roi}));
        std_size_young = std(roi_stats_cohort{coh}(roi).nvoxels(roi_stats_cohort{coh}(roi).age<50));
        eval(sprintf('cohort_roi{coh}.ROI_%s_size_std_young = std_size_young;', ROI_names{roi}));
        try
            mean_xyz_older = mean(roi_stats_cohort{coh}(roi).xyz_mean(:,roi_stats_cohort{coh}(roi).age>=50)')';
            eval(sprintf('cohort_roi{coh}.ROI_%s_mean_older = mean_xyz_older;', ROI_names{roi}));
            std_xyz_older = std(roi_stats_cohort{coh}(roi).xyz_mean(:,roi_stats_cohort{coh}(roi).age>=50)')';
            eval(sprintf('cohort_roi{coh}.ROI_%s_std_older = std_xyz_older;', ROI_names{roi}));
            mean_size_older = mean(roi_stats_cohort{coh}(roi).nvoxels(roi_stats_cohort{coh}(roi).age>=50));
            eval(sprintf('cohort_roi{coh}.ROI_%s_size_older = mean_size_older;', ROI_names{roi}));
            std_size_older = std(roi_stats_cohort{coh}(roi).nvoxels(roi_stats_cohort{coh}(roi).age>=50));
            eval(sprintf('cohort_roi{coh}.ROI_%s_size_std_older = std_size_older;', ROI_names{roi}));
        catch
        end
    end
end


    