function golomb_codewords = adaptive_golomb_coder(run_lengths)
    % ADAPTIVE_GOLOMB_CODER Encodes run-length values using adaptive Golomb coding.
    %
    % Args:
    %   run_lengths: An array of non-negative integer run-length values.
    %
    % Returns:
    %   golomb_codewords: A cell array of binary Golomb codewords.
    
    N = 1;  % Initialize counter
    A = mean(run_lengths); % Estimate average run-length
    Nmax = 256; % Renormalization counter value (you can adjust this)
    
    golomb_codewords = {}; % Initialize output
    
    for r = run_lengths
        % Estimate k
        k = max(0, ceil(log2(A/(2*N))));
    
        % Unary part 
        ru = floor(r / 2^k);  
        unary_code = [repelem('0', 1, ru), '1'];     
        % Constant length part
        rc = mod(r, 2^k);
        binary_code = dec2bin(rc, k); % Fixed-length binary representation
    
        % Concatenate unary and binary parts
        golomb_codewords{end + 1} = [unary_code binary_code];
    
        % Adaptive updates
        if N == Nmax
            A = floor(A/2);
            N = floor(N/2);
        end
        A = A + r;
        N = N + 1;
    end
    
    end
    