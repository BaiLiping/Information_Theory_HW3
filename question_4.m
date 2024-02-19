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
    source_stream_str = generate_markov1(alpha, L);  
    [run_lengths_vector,unique_lengths,pmf] = generate_run_lengths_vector(source_stream_str);
    run_length_encoded = run_length_encoder(run_lengths_vector,unique_lengths, pmf); 
    % Modify run lengths for Golomb encoder (subtract 1)
    modified_run_lengths = run_lengths_vector - 1; 
    % Adaptive Golomb Encoding
    golomb_encoded = adaptive_golomb_encoder(modified_run_lengths);
    arithmatic_encoded = markov1_arithmetic_encoder(source_stream_str, alpha, N, P); 
    % Compression Ratio Calculations
    rle_compression_ratios(i) = L / length(run_length_encoded);
    golomb_compression_ratios(i) = L / length(golomb_encoded);
    arithmatic_compression_ratios(i) = L/length(arithmatic_encoded);
    % Theoretical Compression Ratio
    probabilities = pmf/ length(run_lengths_vector);
    entropy = -sum(probabilities .* log2(probabilities)); 
    theoretical_compression(i) = L / (entropy * length(run_lengths_vector)); 
end

% Plotting
figure;
hold on;
plot(alpha_values, golomb_compression_ratios, 'DisplayName', 'Golomb Encoder', linewidth=2);
plot(alpha_values, arithmatic_compression_ratios, 'DisplayName', 'Arithmatic Encoder', linewidth=2);
plot(alpha_values, theoretical_compression, 'DisplayName', 'Theoretical Encoder', linewidth=2);

hold off;

xlabel('\alpha Values');
ylabel('Compression Ratio');
title('Compression Performance Comparison');
legend('show');
grid on; 