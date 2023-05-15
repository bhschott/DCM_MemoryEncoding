function expvar_list = fade_dcm_extract_vexp(GCM_file)
% extract explained variance for all DCMs in a GCM
% uses the procedure from spm_dcm_fmri_check.m
% written bei Björn Schott, 12.06.2022

if nargin<1
    [GCM_file, dummy] = spm_select(1,'^(D|G)CM.*\.mat$','select DCM or GCM mat');
end

GCMa = load(GCM_file);
GCM = GCMa.GCM;

expvar_list = [];

for ii = 1:length(GCM)
    DCM = GCM{ii};
    PSS   = sum(sum(DCM.y.^2));
    RSS   = sum(sum(DCM.R.^2));
    per_exp_var  = 100*PSS/(PSS + RSS);
    expvar_list = [expvar_list; per_exp_var];
end