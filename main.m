alpha_values = 0.1:0.05:0.9;
L = 19600; % Source stream length 

% Arrays to store calculated values
entropy_markov = zeros(size(alpha_values));
entropy_code = zeros(size(alpha_values));
entropy_rate_markov = zeros(size(alpha_values));
entropy_rate_code = zeros(size(alpha_values));

% Loop over alpha values
for i = 1:length(alpha_values)
    alpha = alpha_values(i);

    % (a) Generate Markov-1 source stream
    source_stream = generate_markov1(alpha, L);

    % (b) Entropy - Markov Stream
    entropy_markov(i) = calculate_entropy(source_stream); 

    % (b) Entropy - Code Stream 
    [encoded_stream, ~] = rlencode(source_stream); 
    run_lengths = encoded_stream(:, 1);
    % Assume simple fixed-length encoding of lengths for entropy estimation
    code_stream_length = size(encoded_stream, 1) * (2 + ceil(log2(max(run_lengths)))); 
    entropy_code(i) = (code_stream_length / L) * calculate_entropy(run_lengths);

    % (c) Entropy Rate - Markov Stream
    entropy_rate_markov(i) = calculate_entropy_rate(source_stream, 1); 

    % (c) Entropy Rate - Code Stream
    entropy_rate_code(i) = calculate_entropy_rate(run_lengths, 10);

    % (d) Compression Ratio
    compression_ratio(i) = L / code_stream_length;
    % ... (Also calculate Golomb compression ratio from your previous code ) ...
end

% == Plotting == 

% (b) Entropy Plot
figure;
plot(alpha_values, entropy_markov, 'b-', alpha_values, entropy_code, 'r--');
xlabel('Alpha (α)');
ylabel('Entropy');
legend('Markov-1 Stream', 'Code Stream');
title('Entropy of Markov-1 Stream vs Code Stream');

% (c) Entropy Rate Plot
figure;
plot(alpha_values, entropy_rate_markov, 'b-', alpha_values, entropy_rate_code, 'r--');
xlabel('Alpha (α)');
ylabel('Entropy Rate');
legend('Markov-1 Stream', 'Code Stream');
title('Entropy Rate of Markov-1 Stream vs Code Stream');

% (d) Compression Ratio Plot
figure;
plot(alpha_values, compression_ratio, 'b-', ...
     alpha_values, compression_ratio_golomb, 'r--'); % Replace with your Golomb ratio 
xlabel('Alpha (α)');
ylabel('Compression Ratio');
legend('Run-Length Encoding', 'Run-Length/Golomb');
title('Compression Ratio Comparison'); 
