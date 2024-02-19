function golomb_code = adaptive_golomb_encoder(run_lengths_vector)
    % Psudocode
    % Initialize
    % N = 1
    % A = initial estimate of the average run-length value
    % Nmax = counter value for renormalization
    % FOR each run-length value r DO
    %     k = max{0, ceil(log2(A/(2*N)))}
    %     % code r using Golomb code with parameter k
    %     ru = floor(r/2^k)
    %     rc = r mod 2^k
    %     r =2^k*ru + rc
    %     IF N = Nmax
    %         A = floor(A/2)
    %         N = floor(N/2)
    %     END
    %     A = A + current run-length value
    %     N = N + 1
    % END
    
    
    N = 1;
    A = mean(run_lengths_vector);
    Nmax = 10; 
    golomb_code = []; 
    for r = run_lengths_vector  
        k = max(0, ceil(log2(A / (2 * N))));
        ru = floor(r / 2^k);
        rc = mod(r, 2^k);
        % Encode ru in unary
        golomb_code = [golomb_code, ones(1, ru), 0];
        % Encode rc in truncated binary
        remainder_bits = dec2bin(rc, k); 
        golomb_code = [golomb_code, remainder_bits - '0']; 
        if N == Nmax
            A = floor(A/2);
            N = floor(N/2);
        end
        A = A + r;
        N = N + 1;
    end
end
