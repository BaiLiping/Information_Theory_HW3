function encoded_bits = markov1_arithmetic_encoder(input_stream, alpha, beta, N, P)
    % Initialization
    C = 0;         % Initialize register C
    A = 2^N;       % Initialize A as 2^N
    r = -1;        % Initialize r as -1 for special state
    b = 0;         % Initialize b, which counts renormalization steps
    encoded_bits = []; % Initialize the output encoded bit stream as empty
    mask = 2^(N+P) - 1; % Mask for modulo operation to keep N+P bits

    scaling_factor = 1000; % Example scaling factor (adjust as needed)
    alpha_scaled = round(alpha * scaling_factor); 
    beta_scaled = round(beta * scaling_factor);

    % Core Encoding Loop
    for n = 1:length(input_stream)
        xn = input_stream(n); % Get the current bit to be encoded
       
        % Determine probability p0 based on the Markov-1 model (with scaled values)
        if n == 1
            p0_scaled = alpha_scaled; % Assume starting with state 0 
        else
            if input_stream(n-1) == 0
                if xn == 0 
                    p0_scaled = (scaling_factor - alpha_scaled); 
                else 
                    p0_scaled = alpha_scaled;
                end
            else
                if xn == 0 
                    p0_scaled = beta_scaled;
                else 
                    p0_scaled = (scaling_factor - beta_scaled); 
                end
            end
        end
    
        T = A * p0_scaled; % Multiply A by the probability p0
    
        if xn == 1 
            C = C + T; % Increment C by T if current bit is 1
        end
        
        % Adjust T with the possibility of overflow
        T = bitshift(A, P) - T; % Equivalent to T = 2^P * A - T
        
        % Check for overflow in register C and adjust if necessary
        if C >= 2^(N+P)
            C = bitand(C, mask); % Modulo operation to keep N+P bits
            encoded_bits = [encoded_bits, 1]; % Emit bit for carry
            if r > 0
                encoded_bits = [encoded_bits, zeros(1, r-1)]; % Emit r-1 zeros
                r = 0; % Reset r
            else
                r = -1; % Set r to special state
            end
        end
    
        % Renormalization loop to ensure T has enough significant bits
        while T < 2^(N+P-1)
            T = 2 * T; % Double T
            C = bitshift(C, 1); % Left shift C to add a zero bit at the end
            
            % Check for overflow in C after renormalization
            if C >= 2^(N+P)
                C = bitand(C, mask); % Modulo operation to keep N+P bits
                if r < 0
                    encoded_bits = [encoded_bits, 1]; % Emit bit for carry
                else
                    r = r + 1; % Increment r
                end
            else
                % If there is no overflow
                if r >= 0
                    encoded_bits = [encoded_bits, 0]; % Emit a 0 bit
                    encoded_bits = [encoded_bits, ones(1, r)]; % Emit r 1s
                end
                r = 0; % Reset r
            end
        end
        A = floor(T / 2^P); % Adjust A based on the new T value
    end
    
    % Finalize encoding by flushing the remaining bits of register C
    if r >= 0
        encoded_bits = [encoded_bits, 0]; % Emit a 0 bit
        encoded_bits = [encoded_bits, ones(1, r)]; % Emit r 1s
    end
    
    % Convert C to binary and append it to the bitstream
    final_bits = dec2bin(bitand(C, mask), N+P) - '0'; % Convert C to binary with N+P bits
    encoded_bits = [encoded_bits, final_bits]; % Append final bits to output
end
