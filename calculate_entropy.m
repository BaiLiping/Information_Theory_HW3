function H = calculate_entropy(source_stream)
    symbol_probs = histcounts(source_stream, 'Normalization', 'probability');
    H = -sum(symbol_probs .* log2(symbol_probs)); % Shannon entropy formula
end
