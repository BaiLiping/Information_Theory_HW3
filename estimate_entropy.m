function H = estimate_entropy(data)
    % Estimates entropy of a binary data stream
    p0 = sum(data == 0) / length(data);
    p1 = 1 - p0;
    
    if p0 == 0 || p1 == 0
        H = 0; % Avoid log(0)
    else
        H = -p0*log2(p0) - p1*log2(p1);
end
    