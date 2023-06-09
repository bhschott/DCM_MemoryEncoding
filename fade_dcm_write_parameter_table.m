% Average DCM data by cohort and age group and
% write results into table (tab-separated text)

num_cohorts = 3;
age_cutoff = 50;
param_Names = {'PPA-PPA', 'PPA-HC', 'PPA-Prc', 'HC-PPA', 'HC-HC', 'HC-Prc', 'Prc-PPA', 'Prc-HC', 'Prc-Prc', 'MEM_PPA-HC', 'MEM_PPA-Prc', 'MEM_HC-PPA', 'MEM_HC-Prc', 'MEM_Prc-PPA', 'MEM_Prc-HC', 'Input_PPA'};
num_params = length(param_Names);
load dcm_params_w_demographics.mat

outfilename = 'table_dcm_params_all.txt';
fid = fopen(outfilename, 'w');

for par = 1:num_params
    % write parameter name
    pname = sprintf('%s\t', param_Names{par});
    outstr = pname;
    for coh = 1:num_cohorts
        % write means and standard deviations, separated by age group
        meanval_y = mean(data_DCM_ABC{coh}(data_age{coh}<age_cutoff,par));   
        stdval_y = std(data_DCM_ABC{coh}(data_age{coh}<age_cutoff,par));
        meanval_o = mean(data_DCM_ABC{coh}(data_age{coh}>=age_cutoff,par));        
        if isnan(meanval_o)
            meanval_o = 0;
        end
        stdval_o = std(data_DCM_ABC{coh}(data_age{coh}>=age_cutoff,par));
        if isnan(stdval_o)
            stdval_o = 0;
        end
        outstr = [outstr sprintf('%3.3f +/- %3.3f\t%3.3f +/- %3.3f', meanval_y, stdval_y, meanval_o, stdval_o)];
        if coh == num_cohorts
            outstr = sprintf('%s\n', outstr);
        else
            outstr = sprintf('%s\t', outstr);
        end
    end
    fprintf(fid, outstr);
end

fclose(fid)