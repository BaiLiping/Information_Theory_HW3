alpha_values = 0.05:0.05:0.95;
optimal_lengths = zeros(length(alpha_values)); 
compression_ratios = zeros(length(alpha_values)); 
L = 19600;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    source_stream_str = generate_markov1(alpha, L);
    % Run-length encoding
    [run_lengths_vector, start_bit] = run_length_encode(source_stream_str); 

    % Calculate optimal bit length 
    optimal_lengths(i) = calculate_optimal_length(run_lengths_vector); 

    % compression ratio is 
    % (length in bits of the binary source stream) / length in bits of the binary code stream) 
    compression_ratios(i) = length(source_stream_str)/optimal_lengths(i);
end



% Plotting the compression ratio vs alpha values with a thicker line
plot(alpha_values, compression_ratios, '-o', 'LineWidth', 2);  % Set line width to 2
xlabel('\alpha Values');
ylabel('Compression Ratio');
title('Compression Ratio vs \alpha Values');
grid on;

% Adding a legend
legend('Compression Ratio', 'Location', 'best');
