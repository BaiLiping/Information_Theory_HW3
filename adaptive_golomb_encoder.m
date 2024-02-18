function golomb_code = adaptive_golomb_encoder(run_lengths)
    % Initialize variables
    N = 1;
    A = mean(run_lengths); % Initial estimate of average run length
    Nmax = 256; % Example value for renormalization
    
    golomb_code = []; % Initialize output
    
    % Process each run-length value
    for i = 1:length(run_lengths)  % Loop through run lengths
        r = run_lengths(i);
        k = max(0, ceil(log2(A/(2*N)))); % Calculate Golomb parameter k
    
        unary_part = [repmat('1', 1, floor(r / 2^k)), '0']; 
        remainder_part = dec2bin(r - 2^k, k);  
        codeword = [unary_part remainder_part];  
        golomb_code = [golomb_code codeword];
        % Adaptive Update
        if N == Nmax
            A = floor(A/2);
            N = floor(N/2);
        end
        A = A + r;
        N = N + 1;
    end
    
end
