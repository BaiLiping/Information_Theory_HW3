function H = calculate_entropy_rate(encoded_stream, m)
    encoded_str = num2str(encoded_stream);
    symbol_counts = [sum(encoded_stream == 0), sum(encoded_stream == 1)];
    symbol_probs = symbol_counts / length(encoded_stream);
    
    block_probs = zeros(1, 2^m);
    for i = m+1:length(encoded_stream)
       context = encoded_str(i-m:i-1);
       context_index = bin2dec(context) + 1; % Convert binary to decimal index
       block_probs(context_index) = block_probs(context_index) + 1;
    end
    block_probs = block_probs / (length(encoded_stream) - m);
    block_entropies = zeros(1, 2^m);
    for i = 1:2^m
        if block_probs(i) > 0
            p = block_probs(i);
            block_entropies(i) = -p * log2(p) - (1-p) * log2(1-p);
        end
    end
    H = block_entropies * block_probs'; 
end
    