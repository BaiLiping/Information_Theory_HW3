function encoded_bits = markov1_arithmetic_encoder(input_stream, alpha, N, P)
    
    % Initialize C=0, A=2^N, r=-1, b=0
    C = 0; 
    A = 2^N; 
    r = -1; 
    b = 0;  
    beta = alpha; 
    encoded_bits = []; 
    mask = 2^(N+P) - 1; 
    scaling_factor = 100; % a scaling factor is added for plotting purpose
    alpha_scaled = round(alpha * scaling_factor); 
    beta_scaled = round(beta * scaling_factor);

    for n = 1:length(input_stream)
        x_current = input_stream(n); 
        % compute for p0
        if n == 1
            p0_scaled = 0.5;
        else
            if input_stream(n-1) == '0'
                if x_current == '0' 
                    p0_scaled = (scaling_factor - alpha_scaled); 
                else 
                    p0_scaled = alpha_scaled;
                end
            else
                if x_current == '0' 
                    p0_scaled = beta_scaled;
                else 
                    p0_scaled = (scaling_factor - beta_scaled); 
                end
            end
        end
        % T = A * p0
        T = A * p0_scaled;
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
