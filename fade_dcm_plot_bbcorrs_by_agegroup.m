% Assuming you have the following cell arrays:
% correlation_matrix - containing correlation coefficients
% bf10_matrix - containing Bayes factors

% Parameter names for the y-axis
param_names = {'PPA-PPA', 'PPA-HC', 'PPA-Prc', 'HC-PPA', 'HC-HC', 'HC-Prc', 'Prc-PPA', 'Prc-HC', 'Prc-Prc', 'MEM_PPA-HC', 'MEM_PPA-Prc', 'MEM_HC-PPA', 'MEM_HC-Prc', 'MEM_Prc-PPA', 'MEM_Prc-HC', 'Input_PPA'};

% Determine the number of cohorts and age groups
num_cohorts = numel(correlation_matrix);
num_age_groups = numel(correlation_matrix{1});

% Set the figure size
figure_width = 900; % Adjust as desired
figure_height = 1200; % Adjust as desired

% Iterate over the age groups
for age_group = 1:num_age_groups
    % Create a new figure for each age group
    figure('Position', [0, 0, figure_width, figure_height]);
    
    correlation_values = [];
    bf_values = [];
    for cohort = 1:num_cohorts
        % Get the correlation coefficients for the current age group
        correlation_values = [correlation_values correlation_matrix{cohort}{age_group}(:, 1)];    
        % Get the Bayes factors for the current age group
        bf_values = [bf_values bf10_matrix{cohort}{age_group}(:, 1)];
    end
    
    % Set NaNs to 0 to plot missing values in white
    correlation_values(isnan(correlation_values)) = 0;
    
    % Plot the heat map
    imagesc(correlation_values);
    
    % Set the colormap for positive (red) and negative (blue) values
    redblue = bluewhitered;
    colormap(redblue);
    
    % Set the range of the color bar
    caxis([-1 1]);
    
    % Add colorbar and axis labels
    colorbar;
    xlabel('Cohort', 'FontSize', 16);
    ylabel('Parameters', 'FontSize', 16);
    
    % Set the x-axis tick labels
    xticks(1:num_cohorts); % Set the tick positions
    xticklabels(1:num_cohorts); % Set the tick labels
    set(gca, 'FontSize', 16); % Set the font size of the axis ticks
    
    % Set the y-axis tick labels (parameter names)
    yticks(1:numel(param_names)); % Set the tick positions
    yticklabels(param_names); % Set the tick labels
    set(gca, 'FontSize', 16); % Set the font size of the axis ticks
    
    % Rotate the y-axis tick labels for better visibility
    set(gca, 'TickLabelInterpreter', 'none');
    set(gca, 'YTickLabelRotation', 45);
    
    % Iterate over the correlation matrix and add markers based on Bayes factors
    [num_params, num_cohorts] = size(correlation_values);
    
    for param = 1:num_params
        for cohort = 1:num_cohorts
            % Get current Bayes factor and plot '#' if > 2 or '##' if > 10
            bf = bf_values(param, cohort);            
            if bf > 10
                text(cohort, param, '##', 'Color', 'black', 'HorizontalAlignment', 'center', 'FontSize', 18);
            elseif bf > 2
                text(cohort, param, '#', 'Color', 'black', 'HorizontalAlignment', 'center', 'FontSize', 18);
            end
        end
    end
end
