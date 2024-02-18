L = 20000;       % Length of the data stream
m = 10;          % Order of entropy estimation
N = 22;          % Encoder constants 
P = 8;           % Encoder constants 

alpha_values = 0.1:0.05:0.9;
markov_entropies = zeros(size(alpha_values));
code_entropies = zeros(size(alpha_values));

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    beta = alpha;

    % Generate Markov-1 stream
    stream = generate_markov1(alpha, L);

    % Entropy rate of Markov-1 stream (reuse function from problem 2)
    markov_entropies(i) = estimate_entropy_rate(stream, m); 

    % Encode with modified arithmetic encoder
    encoded_bits = markov1_arithmetic_encoder(stream, alpha, beta, N, P); 

    % Entropy rate of encoded stream
    code_entropies(i) = estimate_entropy_rate(encoded_bits, m);  
end

plot(alpha_values, markov_entropies, 'o-', alpha_values, code_entropies, 'x-'); 
xlabel('alpha');
ylabel('Estimated Entropy Rate');
legend('Markov-1 Stream', 'Encoded Stream');