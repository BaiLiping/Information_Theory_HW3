function entropy_rate = estimate_entropy_rate(sequence, m)
    % Estimates the entropy rate of a discrete random sequence.
    %
    % Args:
    %   sequence: Input sequence (array of symbols).
    %   m: Memory depth - the number of past values to consider.

    if m < 1
        error('Memory depth (m) must be a positive integer.');
    end

    N = length(sequence);

    % Create a table to store the counts of m-length symbol blocks
    block_counts = zeros(max(sequence)^m, 1); % Assuming symbols are integers

    % Count occurrences of blocks 
    for i = 1:N-m+1
        block = sequence(i:i+m-1);

        % Convert the block to a numeric index (for simplerlicity)
        index = block * max(sequence).^(m-1:-1:0) + 1;

        block_counts(index) = block_counts(index) + 1;
    end

    % Calculate probabilities of m-length blocks
    block_probabilities = block_counts / sum(block_counts);

    % Estimate entropy rate based on conditional entropies
    entropy_rate = 0;
    for k = m-1:-1:1
        entropy_rate = entropy_rate + calculate_conditional_entropy(sequence, k);
    end

    % Add the entropy of the last (unconditioned) symbol
    entropy_rate = entropy_rate + calculate_entropy(sequence(end));
end
