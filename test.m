L = 20000; 
alpha_values = 0.1:0.05:0.9;
markov_entropies = zeros(size(alpha_values));
code_entropies = zeros(size(alpha_values));

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    beta = alpha;
    stream = generate_markov1(alpha, L);
    % Choose your N and P values
    N = 22;
    P = 8;

    % Entropy of Markov-1 stream
    markov_entropies(i) = estimate_entropy(stream); 

    % Encode with modified arithmetic encoder
    encoded_bits = markov1_arithmetic_encoder(stream, alpha, beta, N, P); 

    % Entropy of encoded stream
    code_entropies(i) = estimate_entropy(encoded_bits);  
end

plot(alpha_values, markov_entropies, 'o-', alpha_values, code_entropies, 'x-'); 
xlabel('alpha');
ylabel('Estimated Entropy');
legend('Markov-1 Stream', 'Encoded Stream');
