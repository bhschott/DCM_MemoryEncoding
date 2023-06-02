% Plot correlation matrices as heat maps, requires the variables generated
% with fade_dcm_calculate_bbcorrs.m

columnVarNames = {'Aprime', 'VLMT\_1to5', 'VLMT\_Distractor', 'VLMT\_5min', 'VLMT\_30min', 'VLMT\_1d', 'WMS\_learn', 'WMS\_30min', 'WMS\_1d'};
rowVarNames = {'PPA-PPA', 'PPA-HC', 'PPA-Prc', 'HC-PPA', 'HC-HC', 'HC-Prc', 'Prc-PPA', 'Prc-HC', 'Prc-Prc', 'MEM\_PPA-HC', 'MEM\_PPA-Prc', 'MEM\_HC-PPA', 'MEM\_HC-Prc', 'MEM\_Prc-PPA', 'MEM\_Prc-HC', 'Input\_PPA'};

for coh = 1:num_cohorts
    for ag = 1:n_agrps
        % Get correlation and Bayes factor matrices for the current cohort and age group
        correlation_mat = correlation_matrix{coh}{ag};
        bf10_mat = bf10_matrix{coh}{ag};
        
        % Create figure for the correlation matrix
        figure('Units', 'inches', 'Position', [0, 0, 8, 8]);
        
        % Set colormap for correlation values
        colormap('jet');
        
        % Plot correlation matrix with specified color range
        imagesc(correlation_mat, [-0.6, 0.6]);
        
        % Add colorbar
        colorbar;
        
        % Set axis labels and title
        xlabel('Memory performance measures', 'FontSize', 14);
        ylabel('DCM parameters', 'FontSize', 14);
        switch ag
            case 1
                title(sprintf('Cohort %d, young adults', coh), 'FontSize', 14);
            case 2
                title(sprintf('Cohort %d, older adults', coh), 'FontSize', 14);
        end
        
        % Get the size of the correlation matrix
        [num_params, num_behaviors] = size(correlation_mat);
        
        % Loop through each cell in the correlation matrix
        for param = 1:num_params
            for bhv_ind = 1:num_behaviors
                % Get the Bayes factor for the current cell
                bf10 = bf10_mat(param, bhv_ind);
                
                % Determine the significance level based on Bayes factor
                if bf10 > 10
                    % Display '##' for Bayes factor > 10
                    text_marker = '##';
                elseif bf10 > 2
                    % Display '#' for Bayes factor > 2
                    text_marker = '#';
                else
                    % Desaturate cells with Bayes factor < 2
                    cell_color_transparent = [1, 1, 1, 0.75];
                    rectangle('Position', [bhv_ind-0.5, param-0.5, 1, 1], 'FaceColor', cell_color_transparent, 'EdgeColor', 'none');
                    continue;
                end
                
                % Compute the position of the marker in the cell
                text_x = bhv_ind;  % Centering the marker
                text_y = param;  % Centering the marker
                
                % Display the marker in the cell
                text(text_x, text_y, text_marker, 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
            end
        end
        
        % Set x-axis tick labels using LaTeX syntax
        xticks(1:num_behaviors);
        xticklabels(columnVarNames);
        xtickangle(45);
        
        % Set y-axis tick labels using LaTeX syntax
        yticks(1:num_params);
        yticklabels(rowVarNames);
        
        % Adjust the figure size to accommodate the tick labels
        set(gcf, 'Units', 'inches');
        pos = get(gcf, 'Position');
        pos(4) = pos(4) + 0.5;
        set(gcf, 'Position', pos);
    end
end
