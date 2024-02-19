function H = calculate_entropy_rate(encoded_stream, m)
    % Initialize a map to store context counts
    context_counts = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    % Convert the input stream to char if it is a string
    if isstring(encoded_stream)
        encoded_stream = char(encoded_stream);
    end

    % Count occurrences for each context of length m
    for i = 1:(length(encoded_stream) - m)
        context = encoded_stream(i:i+m-1);
        next_symbol = encoded_stream(i+m);
        
        % Convert context to char to use as a key
        context_char = char(context);
        
        if ~isKey(context_counts, context_char)
            context_counts(context_char) = containers.Map('KeyType', 'char', 'ValueType', 'double');
        end
        symbol_counts = context_counts(context_char);
        if isKey(symbol_counts, char(next_symbol))
            symbol_counts(char(next_symbol)) = symbol_counts(char(next_symbol)) + 1;
        else
            symbol_counts(char(next_symbol)) = 1;
        end

    end
    
    % Initialize total entropy
    total_entropy = 0;
    
    % Calculate conditional entropy for each context
    context_keys = keys(context_counts);
    for i = 1:length(context_keys)
        context = context_keys{i};
        symbol_counts = context_counts(context);
        context_total = sum(cell2mat(values(symbol_counts)));
        context_entropy = 0;
        
        symbol_keys = keys(symbol_counts);
        for j = 1:length(symbol_keys)
            symbol = symbol_keys{j};
            count = symbol_counts(symbol);
            p_symbol_given_context = count / context_total;
            context_entropy = context_entropy - p_symbol_given_context * log2(p_symbol_given_context);
        end
        total_entropy = total_entropy + context_entropy;
    end
    
    % Average the entropy over all contexts
    H = total_entropy / length(context_keys);
end
