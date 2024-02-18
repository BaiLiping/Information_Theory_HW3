function H_est = estimate_entropy_rate(data, m)
    % Estimates entropy rate using block entropy with order 'm'
    
    block_len = m;  
    blocks = reshape(data(1:end-mod(length(data), m)), block_len, []); 
    unique_blocks = unique(blocks.', 'rows');
    
    % Calculate probability of each unique block
    [~, loc] = ismember(blocks.', unique_blocks.', 'rows');
    p = histcounts(loc, 1:size(unique_blocks, 2)) / size(blocks, 2);
        % Block entropy
    H_block = -sum(p .* log2(p)); 
    
    % Estimated entropy rate
    H_est = H_block;  
end
    