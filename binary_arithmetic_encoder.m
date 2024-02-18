function encoded_bits = binary_arithmetic_encoder(input_stream, p0, N, P)
    % Parameters
    % - input_stream: Binary input data stream
    % - p0: Probability of symbol 0 (or transition probability for Markov-1)
    % - N, P: Encoder constants
    
    % Initialization
    C = 0;        % Register to hold intermediate codeword
    A = 2^N;      % Interval width
    r = -1;       % Tracks carry propagation state
    b = 0;        % Counts renormalization operations
    encoded_bits = []; % Output bitstream
    
    % Core Encoding Loop
    for n = 1:length(input_stream)
        xn = input_stream(n); 
        T = A * p0;  % Calculate scaled probability interval
    
        if xn == 1 
            C = C + T;               % Update current codeword position
            T = 2^P * A - T;         % Update interval width 
        end
    
        % Overflow Check
        if C >= 2^(N+P)
            C = bitand(C, 2^(N+P) - 1); % Optimized masking operation 
            encoded_bits = [encoded_bits, 1]; % Emit '1' bit due to overflow
    
            if r > 0
                encoded_bits = [encoded_bits, zeros(1, r)]; % Emit pending '0's
                r = 0;         % Reset carry counter
            else
                r = -1;        % Special state if overflow with no pending '0's
            end
        end
    
       % Renormalization to prevent underflow
        while T < 2^(N+P-1) 
            b = b + 1; 
            T = bitshift(A, P) - T;  % Optimized update of T
            C = bitshift(C, 1);   % Scale current position
    
            if C >= 2^(N+P)  % Handle overflow during renormalization
                C = bitand(C, 2^(N+P) - 1); 
    
                if r < 0
                    encoded_bits = [encoded_bits, 1]; 
                else
                    r = r + 1;  % Increment carry count if '1' followed by '0's
                end
            else 
                if r >= 0
                    encoded_bits = [encoded_bits, 0]; % Emit carry '0'
                    encoded_bits = [encoded_bits, ones(1, r)]; % Emit carry '1's
                end
                r = 0;       % Reset carry counter
            end
        end 
        A = floor(T / 2^P);   % Update remaining interval width
    end
    
    % Termination 
    if r >= 0
        encoded_bits = [encoded_bits, 0]; 
        encoded_bits = [encoded_bits, ones(1, r)]; 
    end
    
    % Emit final bits of register C
    T = bitshift(A, P) - T; 
    C = bitand(C, 2^(N+P) - 1); 
    final_bits = dec2bin(C, N+P) - '0'; % Convert C to binary, adjust for ASCII
    encoded_bits = [encoded_bits, final_bits]; 
end
    