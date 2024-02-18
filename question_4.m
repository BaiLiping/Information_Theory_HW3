clc; clear; close all;

L = 20000; 
alpha_values = 0.1:0.05:0.9;
N = 22;
P = 8;
% Data containers
golomb_compression_ratios = zeros(size(alpha_values));
arithmatic_compression_ratios = zeros(size(alpha_values));
theoretical_compression = zeros(size(alpha_values));


for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    beta = alpha;
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
    arithmatic_encoded = markov1_arithmetic_encoder(source_stream_str, alpha, beta, N, P); 
    
    % Compression Ratio Calculations
    golomb_compression_ratios(i) = L / length(golomb_encoded);
    arithmatic_compression_ratios(i) = L/length(arithmatic_encoded);

end


% Plotting
figure;
hold on;
plot(alpha_values, golomb_compression_ratios, 'DisplayName', 'Golomb Encoder', linewidth=2);
plot(alpha_values, arithmatic_compression_ratios, 'DisplayName', 'Arithmatic Encoder', linewidth=2);
hold off;

xlabel('\alpha Values');
ylabel('Compression Ratio');
title('Compression Performance Comparison');
legend('show');
grid on; 