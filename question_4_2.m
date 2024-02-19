clc; clear; close all;

alpha_values = 0.1:0.05:0.9;
L = 20000; 
N = 22;
P = 8;

% Arrays to store entropies
markov1_entropy = zeros(size(alpha_values));
code_stream_entropy = zeros(size(alpha_values));

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    % Generate Markov-1 Data
    source_stream_str = generate_markov1(alpha, L); 
    source_stream_num = source_stream_str - '0';  
    % Calculate probabilities
    pi0 = sum(source_stream_num == 0) / L;
    pi1 = 1 - p0;
    % H=−π0​[αlog(α)+(1−α)log(1−α)]−π1​[βlog(β)+(1−β)log(1−β)]
    H = -pi0*(alpha*log2(alpha) + (1-alpha)*log2(1-alpha))-pi1*(alpha*log2(alpha) + (1-alpha)*log2(1-alpha));
    markov1_entropy(i)=H;
    encoded_stream = markov1_arithmetic_encoder(source_stream_str, alpha, N, P);
    p0 = sum(encoded_stream == 0) / length(encoded_stream);
    p1 = 1-p0;
    H = -p0*log2(p0) - p1*log2(p1);
    code_stream_entropy(i) = H;
end

% Plotting
figure;
plot(alpha_values, markov1_entropy, 'DisplayName', 'Markov-1 Stream Entropy', linewidth=2);
hold on;
plot(alpha_values, code_stream_entropy, 'DisplayName', 'Coded Stream Entropy', linewidth=2);
hold off;
xlabel('\alpha Values');
ylabel('Estimated Entropy');
title('Entropy of Markov-1 Stream vs. Encoded Stream');
legend('show');
grid on; 