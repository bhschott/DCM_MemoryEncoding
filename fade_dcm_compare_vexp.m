% extraction of explained variances from all three cohorts
% and all slice timing options (TR/nslices, TR/2, TR)
% followed by comparison within and across cohorts

n_cohorts = 3;
n_st_options = 3;
exp_var = cell(n_cohorts,n_st_options);

work_dir = '/Volumes/ArmorATD/projects/FADE_2016/analyses_new/DCM/';
st_dirs = {'DCM_firstresponder_2022-06-10'; 'DCM_firstresponder_2022-06-09'; 'DCM_firstresponder_2022-05-07'};
st_dir_suffs = {'_zeroTR'; '_halfTR'; ''};
co_dir_suffs = {'_3regions_yFADE'; '_verio_3regions'; '_skyra_3regions'};

for st = 1:n_st_options
    for co = 1:n_cohorts
        current_dirname = strcat(work_dir, st_dirs{st}, '/DCM_emppriors', st_dir_suffs{st}, co_dir_suffs{co}, '/');
        current_gcm_name = strcat('GCM_full', st_dir_suffs{st});
        current_gcm_file = strcat(current_dirname, current_gcm_name, '.mat');
        exp_var{st,co} = fade_dcm_extract_vexp(current_gcm_file);
    end
end

stats_list = [];

st_suffs = {'zeroTR'; 'halfTR'; 'fullTR'};
co_suffs = {'yFADE'; 'verio'; 'skyra'};

cmp1 = [1 1 2];
cmp2 = [2 3 3];

for st = 1:n_st_options
    for co = 1:n_cohorts
        [h p ci stats] = ttest(exp_var{cmp1(st),co},exp_var{cmp2(st),co});
        [bfac pb] = bf.ttest(exp_var{cmp1(st),co},exp_var{cmp2(st),co});   
        current_stat.title = strcat(co_suffs{co}, '_', st_suffs{cmp1(st)}, '_', st_suffs{cmp2(st)});
        current_stat.T = stats.tstat;
        current_stat.p = p;
        current_stat.pb = pb;
        current_stat.bf = bfac;
        stats_list = [stats_list current_stat];
    end
end
