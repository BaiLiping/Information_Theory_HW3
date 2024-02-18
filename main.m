alpha_values = 0.1:0.05:0.9;
L = 20000; % Source stream length 

% Arrays to store calculated values
entropy_markov = zeros(size(alpha_values));
entropy_code = zeros(size(alpha_values));
entropy_rate_markov = zeros(size(alpha_values));
entropy_rate_code = zeros(size(alpha_values));
compression_ratio = zeros(size(alpha_values));
compression_ratio_golomb = zeros(size(alpha_values)); 

% Loop over alpha values
for i = 1:length(alpha_values)
    alpha = alpha_values(i);

    % Generate Markov-1 source stream
    source_stream = generate_markov1(alpha, L);
    entropy(i) = calculate_entropy(source_stream); 

    % Run-Length Encoding
    [encoded_stream, lengths] = rlencode(source_stream); 
    run_lengths = encoded_stream(:, 1); 
    code_stream_length = size(encoded_stream, 1) * (2 + ceil(log2(max(run_lengths)))); 
    entropy_code(i) = (code_stream_length / L) * calculate_entropy(run_lengths);

    % Entropy Rate Calculations
    [entropy_rate_markov(i), all_blocks] = calculate_entropy_rate(source_stream, 1); % Capture all_blocks
    entropy_rate_code(i) = calculate_entropy_rate(run_lengths, 10); 

    % Compression Ratios
    compression_ratio(i) = L / code_stream_length; 
    compression_ratio_golomb(i) = compression_ratio_golomb(run_lengths, k); % Choose 'k' for Golomb-Rice
end
% == Plotting == 

% Entropy Plot
figure;
plot(alpha_values, entropy_markov, 'b-', alpha_values, entropy_code, 'r--');
xlabel('Alpha (α)');
ylabel('Entropy');
legend('Markov-1 Stream', 'Code Stream');
title('Entropy of Markov-1 Stream vs Code Stream');

% Entropy Rate Plot
figure;
plot(alpha_values, entropy_rate_markov, 'b-', alpha_values, entropy_rate_code, 'r--');
xlabel('Alpha (α)');
ylabel('Entropy Rate');
legend('Markov-1 Stream', 'Code Stream');
title('Entropy Rate of Markov-1 Stream vs Code Stream');

% Compression Ratio Plot
figure;
plot(alpha_values, compression_ratio, 'b-', ...
     alpha_values, compression_ratio_golomb, 'r--'); % Replace with your Golomb ratio 
xlabel('Alpha (α)');
ylabel('Compression Ratio');
legend('Run-Length Encoding', 'Run-Length/Golomb');
title('Compression Ratio Comparison'); 
