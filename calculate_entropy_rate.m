function [H_rate, all_blocks] = calculate_entropy_rate(source_stream, memory)
    if memory <= 0
        error('Memory must be a positive integer');
    end

    all_blocks = unique(mnr2mat(source_stream, memory), 'rows'); 
    all_blocks_numerical = block2num(all_blocks); 
    block_probs = histcounts(mnr2mat(source_stream, memory), all_blocks_numerical, 'Normalization', 'probability');

    cond_probs = zeros(size(all_blocks, 1), size(all_blocks, 2));
    for i = 1:size(all_blocks, 1)
        block_occurrences = sum(ismember(all_blocks, all_blocks(i, :), 'rows')); 
        block_indices = find(ismember(all_blocks, all_blocks(i, :), 'rows'));
        next_symbols = source_stream(memory + block_indices); 
        cond_probs(i, :) = histcounts(next_symbols, 'Normalization', 'probability');
    end

    H_rate = -sum(block_probs .* sum(cond_probs .* log2(cond_probs), 2)); 
end 
