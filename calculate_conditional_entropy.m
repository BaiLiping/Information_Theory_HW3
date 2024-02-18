function conditional_entropy = calculate_conditional_entropy(sequence, k)
    % Calculates the conditional entropy of a symbol in a sequence,
    % conditioned on the 'k' previous symbols.

    N = length(sequence);

    % Get joint probabilities of blocks of length k+1
    joint_counts = calculate_joint_counts(sequence, k + 1);
    joint_probabilities = joint_counts / sum(joint_counts(:)); % Sum over all dimensions

    % Get marginal probabilities of blocks of length k
    marginal_counts = calculate_marginal_counts(sequence, k);
    marginal_probabilities = marginal_counts / sum(marginal_counts(:));

    % Calculate conditional entropy
    conditional_entropy = 0;
    for i = 1:N-k
        current_block = sequence(i:i+k);     % Joint event 
        past_block = sequence(i:i+k-1);      % Conditioning event 

        % Convert blocks to indices 
        joint_index = convert_block_to_index(current_block);
        marginal_index = convert_block_to_index(past_block);

        % Handle zeros (avoid log2(0))
        if joint_probabilities(joint_index) > 0 && marginal_probabilities(marginal_index) > 0
            conditional_entropy = conditional_entropy + ...
                joint_probabilities(joint_index) * log2(joint_probabilities(joint_index) / marginal_probabilities(marginal_index));
        end
    end

    conditional_entropy = -conditional_entropy; 
end

% --- Helper Functions ---

function counts = calculate_joint_counts(sequence, k)
    N = length(sequence);
    maxSymbol = max(sequence);
    counts = zeros(maxSymbol^k, 1);

    for i = 1:N-k+1
        block = sequence(i:i+k-1);
        index = convert_block_to_index(block);
        counts(index) = counts(index) + 1;
    end
end

function counts = calculate_marginal_counts(sequence, k)
   % (Implementation is very similar to calculate_joint_counts)
   % ... 
end

function index = convert_block_to_index(block)
    maxSymbol = max(block);
    index = block * maxSymbol.^(length(block)-1:-1:0) + 1; 
end
