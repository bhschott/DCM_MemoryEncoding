% Write table with cumulative correlation coefficients and Bayes factors

% Variable names
columnVarNames = {'Aprime', 'VLMT_1to5', 'VLMT_Distractor', 'VLMT_5min', 'VLMT_30min', 'VLMT_1d', 'WMS_learn', 'WMS_30min', 'WMS_1d'};
rowVarNames = {'PPA-PPA', 'PPA-HC', 'PPA-Prc', 'HC-PPA', 'HC-HC', 'HC-Prc', 'Prc-PPA', 'Prc-HC', 'Prc-Prc', 'MEM_PPA-HC', 'MEM_PPA-Prc', 'MEM_HC-PPA', 'MEM_HC-Prc', 'MEM_Prc-PPA', 'MEM_Prc-HC', 'Input_PPA'};

% older adults
meanR_o = weighted_correlation_mean(correlation_matrix{2}{2}, correlation_matrix{3}{2}, n_matrix{2}{2}, n_matrix{3}{2});
BFwO = weighted_bayes_factor(bf10_matrix{2}{2}, bf10_matrix{3}{2}, n_matrix{2}{2}, n_matrix{3}{2});

% Create a cell array to store the results
numRows = length(rowVarNames) * 2 + 1;
numCols = length(columnVarNames) + 1;
results = cell(numRows, numCols);

% Fill in the variable names in the first row and column
results{1, 1} = ''; % Empty cell in the top-left corner
for co = 1:length(columnVarNames)
    results{1, co+1} = columnVarNames{co};
end
for ro = 1:length(rowVarNames)
    results{2*ro, 1} = rowVarNames{ro};
end

% Fill in the correlation coefficients and Bayes factors
for i = 1:length(rowVarNames)
    for co = 1:length(columnVarNames)
        results{2*i, co+1} = sprintf('%3.2f', meanR_o(i, co));
        results{2*i+1, co+1} = sprintf('%3.2f', BFwO(i, co));
    end
end

% Convert the cell array to a tab-separated string
resultString = '';
for i = 1:size(results, 1)
    rowString = sprintf('%s\t', results{i, :});
    rowString(end) = []; % Remove the trailing tab
    resultString = [resultString rowString '\n'];
end

% Write the result string to a file
fileID = fopen('correlation_bayes_factors_o.txt', 'w');
fprintf(fileID, resultString);
fclose(fileID);


% young adults
meanR_y = weighted_correlation_mean(correlation_matrix{1}{1}, correlation_matrix{2}{1}, correlation_matrix{3}{1}, n_matrix{1}{1}, n_matrix{2}{1}, n_matrix{3}{1});
BFwY = weighted_bayes_factor(bf10_matrix{1}{1}, bf10_matrix{2}{1}, bf10_matrix{3}{1}, n_matrix{1}{1}, n_matrix{2}{1}, n_matrix{3}{1});

% Create a cell array to store the results
numRows = length(rowVarNames) * 2 + 1;
numCols = length(columnVarNames) + 1;
results = cell(numRows, numCols);

% Fill in the variable names in the first row and column
results{1, 1} = ''; % Empty cell in the top-left corner
for co = 1:length(columnVarNames)
    results{1, co+1} = columnVarNames{co};
end
for ro = 1:length(rowVarNames)
    results{2*ro, 1} = rowVarNames{ro};
end

% Fill in the correlation coefficients and Bayes factors
for i = 1:length(rowVarNames)
    for co = 1:length(columnVarNames)
        results{2*i, co+1} = sprintf('%3.2f', meanR_y(i, co));
        results{2*i+1, co+1} = sprintf('%3.2f', BFwY(i, co));
    end
end

% Convert the cell array to a tab-separated string
resultString = '';
for i = 1:size(results, 1)
    rowString = sprintf('%s\t', results{i, :});
    rowString(end) = []; % Remove the trailing tab
    resultString = [resultString rowString '\n'];
end

% Write the result string to a file
fileID = fopen('correlation_bayes_factors_y.txt', 'w');
fprintf(fileID, resultString);
fclose(fileID);

