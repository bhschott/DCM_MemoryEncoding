% Write table with cumulative correlation coefficients and Bayes factors

% Variable names
columnVarNames = {'Aprime', 'VLMT_1to5', 'VLMT_Distractor', 'VLMT_5min', 'VLMT_30min', 'VLMT_1d', 'WMS_learn', 'WMS_30min', 'WMS_1d'};
rowVarNames = {'PPA-PPA', 'PPA-HC', 'PPA-Prc', 'HC-PPA', 'HC-HC', 'HC-Prc', 'Prc-PPA', 'Prc-HC', 'Prc-Prc', 'MEM_PPA-HC', 'MEM_PPA-Prc', 'MEM_HC-PPA', 'MEM_HC-Prc', 'MEM_Prc-PPA', 'MEM_Prc-HC', 'Input_PPA'};

% Older adults
numRows = length(rowVarNames);
numCols = length(columnVarNames);
meanR_o = zeros(numRows, numCols);
BFwO = zeros(numRows, numCols);

for i = 1:numRows
    for j = 1:numCols
        rs_o = [correlation_matrix{2}{2}(i,j), correlation_matrix{3}{2}(i,j)];
        ns_o = [n_matrix{2}{2}(i,j), n_matrix{3}{2}(i,j)];
        [meanR_o(i,j), BFwO(i,j)] = meta_correlation_bf(rs_o, ns_o);
    end
end

% Create a cell array to store the results
numRows = length(rowVarNames) * 2 + 1;
numCols = length(columnVarNames) + 1;
results_o = cell(numRows, numCols);

% Fill in the variable names in the first row and column
results_o{1, 1} = ''; % Empty cell in the top-left corner
for co = 1:length(columnVarNames)
    results_o{1, co+1} = columnVarNames{co};
end
for ro = 1:length(rowVarNames)
    results_o{2*ro, 1} = rowVarNames{ro};
end

% Fill in the correlation coefficients and Bayes factors
for i = 1:length(rowVarNames)
    for co = 1:length(columnVarNames)
        results_o{2*i, co+1} = sprintf('%3.2f', meanR_o(i, co));
        results_o{2*i+1, co+1} = sprintf('%3.2f', BFwO(i, co));
    end
end

% Convert the cell array to a tab-separated string
resultString_o = '';
for i = 1:size(results_o, 1)
    rowString = sprintf('%s\t', results_o{i, :});
    rowString(end) = []; % Remove the trailing tab
    resultString_o = [resultString_o rowString '\n'];
end

% Write the result string to a file
fileID = fopen('correlation_bayes_factors_older.txt', 'w');
fprintf(fileID, resultString_o);
fclose(fileID);


% Young adults
numRows = length(rowVarNames);
numCols = length(columnVarNames);
meanR_y = zeros(numRows, numCols);
BFwY = zeros(numRows, numCols);

for i = 1:numRows
    for j = 1:numCols 
        rs_y = [correlation_matrix{1}{1}(i,j), correlation_matrix{2}{1}(i,j), correlation_matrix{3}{1}(i,j)];
        ns_y = [n_matrix{1}{1}(i,j), n_matrix{2}{1}(i,j), n_matrix{3}{1}(i,j)];
        [meanR_y(i,j), BFwY(i,j)] = meta_correlation_bf(rs_y, ns_y);
   end
end

% Create a cell array to store the results
numRows = length(rowVarNames) * 2 + 1;
numCols = length(columnVarNames) + 1;
results_y = cell(numRows, numCols);

% Fill in the variable names in the first row and column
results_y{1, 1} = ''; % Empty cell in the top-left corner
for co = 1:length(columnVarNames)
    results_y{1, co+1} = columnVarNames{co};
end
for ro = 1:length(rowVarNames)
    results_y{2*ro, 1} = rowVarNames{ro};
end

% Fill in the correlation coefficients and Bayes factors
for i = 1:length(rowVarNames)
    for co = 1:length(columnVarNames)
        results_y{2*i, co+1} = sprintf('%3.2f', meanR_y(i, co));
        results_y{2*i+1, co+1} = sprintf('%3.2f', BFwY(i, co));
    end
end

% Convert the cell array to a tab-separated string
resultString_y = '';
for i = 1:size(results_y, 1)
    rowString = sprintf('%s\t', results_y{i, :});
    rowString(end) = []; % Remove the trailing tab
    resultString_y = [resultString_y rowString '\n'];
end

% Write the result string to a file
fileID = fopen('correlation_bayes_factors_young.txt', 'w');
fprintf(fileID, resultString_y);
fclose(fileID);
