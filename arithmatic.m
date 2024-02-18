function encoded_bits = arithmatic(source_stream, alpha, N, P)
    % Encodes a binary Markov-1 source using a modified arithmetic encoder.
    %
    % Args:
    %   source_stream: Binary input stream (array of 0s and 1s).
    %   alpha: Transition probability (equal for 0->1 and 1->0 since alpha = beta).
    %   N: Precision parameter.
    %   P: Scaling parameter.

    p0 = 1 - alpha;  % Transition probability for staying in the same state

    C = 0;
    A = 2^N;
    r = -1;
    b = 0;
    encoded_bits = []; % Store the output bits

    for xn = source_stream
        T = A * p0;

        if xn == 1
            C = C + T;
            T = 2^P * A - T; 
        end

        % Carry/Borrow Handling and Bit Emission
        while C >= 2^(N+P)
            C = mod(C, 2^(N+P));
            encoded_bits = [encoded_bits 1]; 

            if r > 0
                encoded_bits = [encoded_bits zeros(1, r-1)]; 
                r = 0;
            else
                r = -1; 
            end
        end

        % Renormalization
        while T < 2^(N+P-1) 
            b = b + 1;
            T = 2 * T;
            C = 2 * C;

            if C >= 2^(N+P) 
                C = mod(C, 2^(N+P)); 
                if r < 0
                    encoded_bits = [encoded_bits 1]; 
                else
                    r = r + 1; 
                end
            else 
                if r >= 0
                    encoded_bits = [encoded_bits 0];
                    encoded_bits = [encoded_bits ones(1, r)]; 
                end
                r = 0;
            end
        end

        A = floor(T / 2^P);
    end

    % Termination
    if r >= 0
        encoded_bits = [encoded_bits 0];
        encoded_bits = [encoded_bits ones(1, r)];
    end 
    encoded_bits = [encoded_bits, bitshift(C, -(N+P))]; % Final bits from C

end
