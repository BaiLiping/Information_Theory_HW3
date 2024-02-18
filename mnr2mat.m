function blocks = mnr2mat(data, block_size)
    % Creates a matrix where each row is a block of 'block_size' consecutive elements
    blocks = zeros(length(data) - block_size + 1, block_size);
    for i = 1:size(blocks, 1)
        blocks(i, :) = data(i:i + block_size - 1);
    end
end
