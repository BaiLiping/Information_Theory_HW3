clc; clear; close all;

alpha_values = 0.05:0.05:0.95;
alpha_pmf_plot = [0.05, 0.5, 0.95];
indices = [1,10,19]; 
rle_code_lengths = zeros(size(alpha_values));
rle_code = zeros(size(alpha_values));
huff_code_lengths = zeros(size(alpha_values)); 
compression_ratios = zeros(size(alpha_values));  
all_unique_lengths = []; 
pmf_data = cell(length(alpha_values), 1); 

L = 19600;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    source_stream_str = generate_markov1(alpha, L);  
    [run_lengths_vector, start_bit] = run_length_encoder(source_stream_str);

    unique_lengths = unique(run_lengths_vector);
    frequencies = histc(run_lengths_vector, unique_lengths);
    pmf = frequencies / length(run_lengths_vector);

    [codeword, huff_code_lengths(i)] = run_length_encoder_length(run_lengths_vector,unique_lengths, pmf); 
    rle_code_lengths(i)=length(codeword);
    % Calculate compression ratio (approximate)
    compression_ratios(i) = L / rle_code_lengths(i);
    all_unique_lengths = union(all_unique_lengths, unique_lengths);

        % Create a struct to store data for this alpha value
    alpha_data = struct(...
        'alpha', alpha_values(i), ...
        'lengths', unique_lengths, ...
        'pmf', pmf, ...
        'codeword', codeword, ... 
        'rle_code_length', rle_code_lengths(i), ...
        'huff_code_length', huff_code_lengths(i), ...
        'compression_ratio', compression_ratios(i) ...
    );

    
    % Store PMF data with a valid field name
    %pmf_data{i} = struct('lengths', unique_lengths, 'pmf', pmf); 
    pmf_data{i} = alpha_data;
end

% Initialize data for plotting
pmf_comparison_unique_length = all_unique_lengths;
pmf_comparison_pmf = zeros(length(alpha_pmf_plot), length(all_unique_lengths));

% Fill in the PMF data using vectorization
for i = 1:length(alpha_pmf_plot)
    index = indices(i);
    alpha_data = pmf_data{index}; 

    % Find positions of matching lengths directly
    length_positions = ismember(pmf_comparison_unique_length, alpha_data.lengths); 

    % Assign PMF values in one operation
    pmf_comparison_pmf(i, length_positions) = alpha_data.pmf; 
end

% PMF Plot 
colors = ['r', 'g', 'b']; 
figure;
hold on; 
for i = 1:length(alpha_pmf_plot)
    plot(pmf_comparison_unique_length, pmf_comparison_pmf(i, :), ...
         'Color', colors(i), 'LineWidth', 2, 'DisplayName', sprintf('alpha = %0.2f', alpha_pmf_plot(i)));
end
hold off;

% Change y-axis to log scale
set(gca, 'YScale', 'log');  

% Add labels, title, and legend
xlabel('Run Length'); 
ylabel('PMF (log scale)'); 
title('PMF Comparison for Different \alpha Values');
legend('show'); 
grid on; 


% Plotting the compression ratio vs alpha values with a thicker line
figure;
plot(alpha_values, compression_ratios, '-o', 'LineWidth', 2);  % Set line width to 2
xlabel('\alpha Values');
ylabel('Compression Ratio');
title('Compression Ratio vs \alpha Values');
grid on;

% Adding a legend
legend('Compression Ratio', 'Location', 'best');
