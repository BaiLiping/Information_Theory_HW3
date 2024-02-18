function optimal_bit_length = calculate_optimal_bit_length(run_length_values)
    % This function calculates the optimal length (in bits) of a binary stream 
    % encoded from an array of run-length values.
    
    % 1. Calculate frequencies of each run-length value
    frequencies = tabulate(run_length_values);
    run_lengths = frequencies(:, 1);
    counts = frequencies(:, 2);

    % Normalize counts to get probabilities
    probabilities = counts / sum(counts); 

    % Use Huffman coding for optimal encoding
    dict = huffmandict(run_lengths, probabilities);  

    
    % Calculate codeword lengths for each run-length value
    codeword_lengths = zeros(size(run_lengths));
    for i = 1:length(run_lengths)
       codeword = dict(run_lengths(i), 2);
       codeword_lengths(i) = length(codeword); 
    end
    
    % 4. Calculate total bit length 
    optimal_bit_length = sum(counts .* codeword_lengths);
end
    