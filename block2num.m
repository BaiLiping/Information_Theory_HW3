function num_rep = block2num(blocks)
    base = 2; % For binary blocks
    num_rep = sum(blocks .* base.^(size(blocks, 2)-1:-1:0), 2); 
end
