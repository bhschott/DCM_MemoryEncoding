% Plot correlation matrices as heat maps, requires the variables generated
% with fade_dcm_calculate_bbcorrs.m

for coh = 1:num_cohorts
    for ag = 1:n_agrps
        % Get correlation and p-value matrices for the current cohort and age group
        correlation_mat = correlation_matrix{coh}{ag};
        correlation_mat = correlation_mat(1:15,:); % skip C matrix
        p_value_mat = p_value_matrix{coh}{ag};
        
        % Create figure for the correlation matrix
        figure('Units', 'inches', 'Position', [0, 0, 8, 8]);
        
        % Set colormap for correlation values
        colormap('jet');
        
        % Plot correlation matrix with specified color range
        imagesc(correlation_mat, [-0.6, 0.6]);
        
        % Add colorbar
        colorbar;
        
        % Set axis labels and title
        xlabel('Behavioral Parameters');
        ylabel('DCM Parameters');
        title(sprintf('Correlation Matrix (Cohort %d, Age Group %d)', coh, ag));
        
        % Get the size of the correlation matrix
        [num_params, num_behaviors] = size(correlation_mat);
        
        % Loop through each cell in the correlation matrix
        for param = 1:num_params
            for bhv_ind = 1:num_behaviors
                % Get the p-value for the current cell
                p_value = p_value_mat(param, bhv_ind);
                
                % Determine the significance level based on p-value
                if p_value < 0.05
                    % Perform FDR correction for number of DCM parameters
                    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_value_mat(:,bhv_ind));
                    adj_p_value = adj_p(param);
                    if adj_p_value < 0.05
                        % Display ** for p < 0.05, FDR-corrected
                        text_marker = '**';
                    else
                        % Display * for p < 0.05
                        text_marker = '*';
                    end
                    
                    % Compute the position of the asterisk in the cell
                    text_x = bhv_ind;  % Centering the asterisk
                    text_y = param;  % Centering the asterisk
                    
                    % Desaturate non-significant cells
                    
                    % Display the asterisk in the cell
                    text(text_x, text_y, text_marker, 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                else                  
                    % use transparent white to desaturate non-significant
                    % cells
                    cell_color_transparent = [1, 1, 1, 0.75];
                    
                    % Fill the cell with the desaturated color
                    rectangle('Position', [bhv_ind-0.5, param-0.5, 1, 1], 'FaceColor', cell_color_transparent, 'EdgeColor', 'none');
                    
                end
            end
        end
    end
end
