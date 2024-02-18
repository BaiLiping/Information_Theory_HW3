clc; clear; close all;

alpha_values = 0.05:0.05:0.95;
% Data containers
rle_compression_ratios = zeros(size(alpha_values));
golomb_compression_ratios = zeros(size(alpha_values));
theoretical_compression = zeros(size(alpha_values));

L = 19600;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    source_stream_str = generate_markov1(alpha, L);  
    [run_lengths_vector, start_bit] = run_length_encoder(source_stream_str);

    unique_lengths = unique(run_lengths_vector);
    frequencies = histc(run_lengths_vector, unique_lengths);
    pmf = frequencies / length(run_lengths_vector);

    [codeword, huff_code_length] = run_length_encoder_length(run_lengths_vector,unique_lengths, pmf); 

    % Modify run lengths for Golomb encoder (subtract 1)
    modified_run_lengths = run_lengths_vector - 1; 

    % Adaptive Golomb Encoding
    golomb_encoded = adaptive_golomb_encoder(modified_run_lengths);
    
    % Compression Ratio Calculations
    rle_compression_ratios(i) = L / length(codeword);
    golomb_compression_ratios(i) = L / length(golomb_encoded);
    
    % Theoretical Compression Ratio
    [unique_lengths, ~, idx] = unique(run_lengths_vector); 
    probabilities = accumarray(idx, 1) / length(run_lengths_vector);
    entropy = -sum(probabilities .* log2(probabilities)); 
    theoretical_compression(i) = L / (entropy * length(run_lengths_vector)); 
end


% Plotting
figure;
plot(alpha_values, rle_compression_ratios, 'DisplayName', 'Run-Length Encoder', linewidth=2);
hold on;
plot(alpha_values, golomb_compression_ratios, 'DisplayName', 'Golomb Encoder', linewidth=2);
plot(alpha_values, theoretical_compression, 'DisplayName', 'Ideal Encoder', linewidth=2);
hold off;

xlabel('\alpha Values');
ylabel('Compression Ratio');
title('Compression Performance Comparison');
legend('show');
grid on; 