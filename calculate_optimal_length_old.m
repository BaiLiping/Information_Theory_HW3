function optimal_length = calculate_optimal_length(run_lengths)
   % Calculate frequencies of each run-length
   unique_lengths = unique(run_lengths);
   frequencies = histc(run_lengths, unique_lengths);
   probabilities = frequencies/length(run_lengths);

   % Huffman coding for unique_lengths
   [dict, avg_len] = huffmandict(unique_lengths, probabilities); 

    % Initialize total length
    code_length = 0;

    % Iterate over each run_length and find its code length in the dictionary
    for i = 1:length(run_lengths)
        % Find the index in dict where the symbol matches run_lengths(i)
        index = find([dict{:, 1}] == run_lengths(i));
        if ~isempty(index)
            code = dict{index, 2}; % Get the Huffman code for the symbol
            code_length = length(code); % Get the length of the code
            code_length = code_length + code_length; % Sum up the code lengths
        end
    end
end