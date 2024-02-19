function encoded_bits = markov1_arithmetic_encoder(input_stream, alpha, N, P)
    
    % Initialize C=0, A=2^N, r=-1, b=0
    C = 0; 
    A = 2^N; 
    r = -1; 
    b = 0;  
    beta = alpha; 
    encoded_bits = []; 
    mask = 2^(N+P) - 1; 

    for n = 1:length(input_stream)
        x_current = input_stream(n); 
        % compute for fx0
        % notice that for memory less source, fx0 and fx1 is constant
        % however, for markov1 proces, fx0 and fx1 changes depending on the previous bit 
        if n == 1
            fx0 = 0.5;
        else
            if input_stream(n-1) == '0'
                if x_current == '0' 
                    fx0 = 1-alpha; 
                else 
                    fx1 = alpha;
                end
            else
                if x_current == '0' 
                    fx0 = beta;
                else 
                    fx1 = 1-beta; 
                end
            end
        end
        % T = A * p0
        % p0 = ⌊2^P* f_X(x = 0)⌋
        p0 =floor(2^P*fx0);
        T = A * p0;
        % IF xn = 1
        %     C = C + T
        %     T = bitshift(A,P) - T;
        % END
        if x_current == '1' 
            C = C + T; % Increment C by T if current bit is 1
            % Equivalent to T = 2^P * A - T
            T = bitshift(A, P) - T;            
        end
        % IF C >= 2^(N+P)
        %     C = bitand(C, mask)
        %     % propagate carry
        %     emit-bit(1)
        %     IF r>0
        %         execute r-1 times, emit-bit(0)
        %         SET r=0
        %     ELSE
        %         SET r=-1
        %     END
        % END
        if C >= 2^(N+P)
            % Modulo operation to keep N+P bits
            C = bitand(C, mask); 
            % carry bit
            encoded_bits = [encoded_bits, 1]; 
            if r > 0
                encoded_bits = [encoded_bits, zeros(1, r-1)];
                r = 0; 
            else
                r = -1;
            end
        end
       % WHILE T < 2^(N+P-1) 
       %         % renormalize once
       %         b = b + 1
       %         T = 2 * T
       %         C = 2 * C
       %     IF C >= 2^(N+P)
       %         C = bitand(C, mask)
       %         % overflow of C
       %         IF r<0
       %             emit-bit(1)
       %         ELSE
       %             r = r + 1
       %         END
       %     ELSE
       %         % no overflow of C
       %         IF r>=0
       %             emit-bit(0)
       %             execute r times, emit-bit(1)
       %         END
       %         SET r = 0
       %     END
       % END
        while T < 2^(N+P-1)
            b = b + 1;  
            T = 2 * T;
            C = 2 * C; 
            
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
        % SET A = floor(T / 2^P)
        A = floor(T / 2^P); % Adjust A based on the new T value
    % END (for)
    end
    % IF r>= 0
    %     emit-bit(0)
    %     execute r times, emit-bit(1)
    % END
    if r >= 0
        encoded_bits = [encoded_bits, 0]; % Emit a 0 bit
        encoded_bits = [encoded_bits, ones(1, r)]; % Emit r 1s
    end
    
    % emit N+P bits of register C
    final_bits = dec2bin(bitand(C, mask), N+P) - '0'; 
    encoded_bits = [encoded_bits, final_bits]; 
end
