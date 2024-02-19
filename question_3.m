clc; clear; close all;

alpha_values = 0.05:0.05:0.95;
% Data containers
rle_compression_ratios = zeros(size(alpha_values));
golomb_compression_ratios = zeros(size(alpha_values));
theoretical_compression = zeros(size(alpha_values));
entropy_record = zeros(size(alpha_values));
rle_length_record = zeros(size(alpha_values));


L = 19600;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    source_stream_str = generate_markov1(alpha, L);  
    [run_lengths_vector,unique_lengths,pmf] = generate_run_lengths_vector(source_stream_str);
    run_length_encoded = run_length_encoder(run_lengths_vector,unique_lengths, pmf); 

    % Modify run lengths for Golomb encoder (subtract 1)
    modified_run_lengths = run_lengths_vector - 1; 
    % Adaptive Golomb Encoding
    golomb_encoded = adaptive_golomb_encoder(modified_run_lengths);
    % Compression Ratio Calculations
    rle_compression_ratios(i) = L / length(run_length_encoded);
    golomb_compression_ratios(i) = L / length(golomb_encoded);
    % Theoretical Compression Ratio
    N = length(run_lengths_vector);
    rle_length_record(i)=N;
    probabilities = pmf/N;
    entropy = -sum(probabilities .* log2(probabilities)); 
    entropy_record(i)=entropy;
    theoretical_compression(i) = L / (entropy * N); 
end


% Plotting
figure;
plot(alpha_values, rle_compression_ratios, 'DisplayName', 'Run-Length Encoder', linewidth=2);
hold on;
plot(alpha_values, golomb_compression_ratios, 'DisplayName', 'Golomb Encoder', linewidth=2);
plot(alpha_values, theoretical_compression, 'DisplayName', 'Theoretical Encoder', linewidth=2);

hold off;

xlabel('\alpha Values');
ylabel('Compression Ratio');
title('Compression Performance Comparison');
legend('show');
grid on; 

figure;
plot(alpha_values, entropy_record, 'DisplayName', 'Entropy', linewidth=2);
xlabel('\alpha Values');
ylabel('Entropy');
title('Entropy');
legend('show');
grid on; 

figure;
plot(alpha_values, rle_length_record, 'DisplayName', 'rle code length', linewidth=2);
xlabel('\alpha Values');
ylabel('Code Length');
title('Code Length');
legend('show');
grid on; 