function entropy = calculate_entropy(sequence)
    % Calculates the Shannon entropy of a given sequence.
    %
    % Args:
    %   sequence: A list or array of symbols (can be numeric or characters).

    % Count the occurrences of each symbol
    symbol_counts = tabulate(sequence);
    probabilities = symbol_counts(:, 2) / sum(symbol_counts(:, 2)); 
    % Filter out zero probabilities (these don't contribute to entropy)
    probabilities = probabilities(probabilities > 0);

    % Calculate the entropy using the formula H = -sum(p_i * log2(p_i))
    entropy = -sum(probabilities .* log2(probabilities));
end
