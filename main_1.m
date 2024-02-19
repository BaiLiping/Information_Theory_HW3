alpha_values = 0.05:0.05:0.95;
optimal_bit_lengths = zeros(size(alpha_values)); % Store optimal lengths
compression_ratios = zeros(size(alpha_values));  % Store compression ratios
L = 19600;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    source_stream = generate_markov1(alpha, L);

    % Run-length encoding
    % Run-length encoding
    [encoded_stream, start_bit] = rlencode(source_stream); 
    run_lengths = encoded_stream(:, 1);

    % Calculate optimal bit length 
    optimal_bit_lengths(i) = calculate_optimal_bit_length(run_lengths); 

    % Calculate compression ratio (approximate)
    source_stream_length = length(source_stream); % Original length in bits
    code_stream_length = size(encoded_stream, 1) * 2; % 2 bits per (length, value) pair
    compression_ratios(i) = source_stream_length / code_stream_length;

    % Adjustment for Golomb encoder input
    run_lengths = run_lengths - 1; 

    % Ideal entropy-based compression ratio
    H_rl = -(alpha*log2(alpha) + (1-alpha)*log2(1-alpha)); 
    compression_ratio_ideal(i) = H_rl / mean(run_lengths);

    % Adaptive Golomb compression
    golomb_codewords = adaptive_golomb_coder(run_lengths);
    compressed_length = sum(cellfun(@length, golomb_codewords)); 
    compression_ratio_adaptive(i) = L / compressed_length;
end

plot(alpha_values, compression_ratio_ideal, 'b--', ...
     alpha_values, compression_ratio_adaptive, 'r-');
xlabel('alpha');
ylabel('Compression Ratio');
legend('Ideal Run-Length Encoder', 'Adaptive Golomb');
title('Compression Performance of Concatenated Encoder');


% Plot compression ratio vs alpha
figure;
plot(alpha_values, compression_ratios);
xlabel('Alpha (α)');
ylabel('Compression Ratio');
title('Compression Ratio vs Alpha');

% Plot PMFs of run-length values
figure;
hold on;
for i = [1, floor(length(alpha_values)/2), length(alpha_values)] % Sample alpha values
    source_stream = generate_markov1(alpha_values(i), L);
    source_stream_str = num2str(source_stream);
    [encoded_stream, ~] = rlencode(source_stream_str);
    lengths = encoded_stream(:, 1);

    pmf = hist(lengths, 1:max(lengths)) / sum(lengths); % Calculate PMF 
    plot(1:max(lengths), pmf);
end
xlabel('Run Length');
ylabel('Probability');
title('PMF of Run-Length Values');
legend('α = 0.05', 'α = 0.5', 'α = 0.95');