function [encoded_output, huff_length] = run_length_encoder(run_lengths,unique_lengths,pmf)

   % Huffman coding for unique_lengths
   [dict, huff_length] = huffmandict(unique_lengths, pmf); 

    % Initialize the encoded output 
    encoded_output = '';

    % Iterate over each run_length and encode using the dictionary
    for i = 1:length(run_lengths)
        % Find the index in dict where the symbol matches run_lengths(i)
        index = find([dict{:, 1}] == run_lengths(i));
        if ~isempty(index)
            code = dict{index, 2}; % Get the Huffman code for the symbol
            encoded_output = [encoded_output code]; % Concatenate the code
        end
    end
end 