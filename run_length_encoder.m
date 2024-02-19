function run_length_encoded = run_length_encoder(run_lengths_vector,unique_lengths,pmf)
   % Huffman coding for unique_lengths
   probabilities = pmf/length(run_lengths_vector);
   [dict, huff_length] = huffmandict(unique_lengths, probabilities); 

    % Initialize the encoded output 
    run_length_encoded = '';

    % Iterate over each run_length and encode using the dictionary
    for i = 1:length(run_lengths_vector)
        % Find the index in dict where the symbol matches run_lengths_vector(i)
        index = find([dict{:, 1}] == run_lengths_vector(i));
        if ~isempty(index)
            code = dict{index, 2}; % Get the Huffman code for the symbol
            run_length_encoded = [run_length_encoded code]; % Concatenate the code
        end
    end
end 