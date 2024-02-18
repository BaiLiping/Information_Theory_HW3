function code = markov1_aritheco(seq, alpha, beta, N)
    % Initialization
    dec_low = 0;  % Lower bound 
    dec_up = 2^N - 1;  % Upper bound
    E3_count = 0;  
    code = [];  % Output code

    % Main Encoding Loop
    for k = 1:length(seq)
        symbol = seq(k);
        xn = symbol - 1; % Assuming symbols are represented as 0 and 1    

        % Calculate p0 based on the Markov-1 model 
        if k == 1
            p0 = alpha; % Assume starting with state 0 
        else
            xn_prev = seq(k - 1) - 1; % Previous symbol (0 or 1)
            if xn_prev == 0
                if xn == 0
                    p0 = 1 - alpha;
                else
                    p0 = alpha;
                end
            else
                if xn == 0
                    p0 = beta;
                else
                    p0 = 1 - beta;
                end
            end
        end

        % Update Lower and Upper Bounds
        dec_low_new = dec_low + floor((dec_up - dec_low + 1) * p0);
        dec_up = dec_low + floor((dec_up - dec_low + 1) * p0) - 1;
        dec_low = dec_low_new;

        % E1, E2, E3 Handling
        while (isequal(bitget(dec_low, N), bitget(dec_up, N)) || ...
               (isequal(bitget(dec_low, N-1), 1) && isequal(bitget(dec_up, N-1), 0)) )

            if isequal(bitget(dec_low, N), bitget(dec_up, N))
                % Emit the MSB
                code = [code, bitget(dec_low, N)]; 

                % Left shifts
                dec_low = bitshift(dec_low, 1); 
                dec_up = bitshift(dec_up, 1) + 1; 

                % Handle accumulated E3 cases
                if E3_count > 0
                    code = [code, ~code(end)*ones(1, E3_count)]; 
                    E3_count = 0;
                end
            else % E3 Condition
                % Left shifts
                dec_low = bitshift(dec_low, 1); 
                dec_up = bitshift(dec_up, 1) + 1; 

                % Complement MSB of dec_low and dec_up
                dec_low = bitxor(dec_low, 2^(N-1));
                dec_up = bitxor(dec_up, 2^(N-1));

                E3_count = E3_count + 1;
            end
        end
    end

    % Termination 
    if E3_count == 0
        code = [code,  int2bit(dec_low, N)'];
    else 
        code = [code, bitget(dec_low, N)];  % Emit MSB
        code = [code, ~code(end)*ones(1, E3_count)]; % Handle E3
        code = [code, int2bit(dec_low, N)[2:end]']; % Remaining bits
    end
end
