% --- Modified Binary Arithmetic Encoder (for Markov-1) ---
function encoded_bits = markov1_arithmetic_encoder(input_stream, alpha, beta, N, P)
    % Parameters
    % - input_stream: Binary input data stream
    % - alpha, beta: Transition probabilities of the Markov-1 source
    % - N, P: Encoder constants
    
    % Initialization
    C = 0;        
    A = 2^N;      
    r = -1;
    b = 0;        
    encoded_bits = []; 
    
    % Core Encoding Loop
    for n = 1:length(input_stream)
        xn = input_stream(n);
       
        if xn == 0
            if input_stream(max(1, n-1)) == 0  % Check previous state
                 p0 = 1 - alpha;  
            else
                 p0 = beta;       
            end
        else 
            if input_stream(max(1, n-1)) == 0
                 p0 = alpha;
            else
                 p0 = 1 - beta;
            end        
        end
    
        T = A * p0; 
    
        if xn == 1 
            C = C + T;              
            T = 2^P * A - T;        
        end
    
        % Overflow Check
        if C >= 2^(N+P)
            C = bitand(C, 2^(N+P) - 1); 
            encoded_bits = [encoded_bits, 1];
    
            if r > 0
                encoded_bits = [encoded_bits, zeros(1, r)]; 
                r = 0;         
            else
                r = -1;       
            end
        end
    
       % Renormalization to prevent underflow
        while T < 2^(N+P-1) 
            b = b + 1; 
            T = bitshift(A, P) - T;  
            C = bitshift(C, 1);   
    
            if C >= 2^(N+P)  
                C = bitand(C, 2^(N+P) - 1); 
    
                if r < 0
                    encoded_bits = [encoded_bits, 1]; 
                else
                    r = r + 1;  
                end
            else 
                if r >= 0
                    encoded_bits = [encoded_bits, 0]; 
                    encoded_bits = [encoded_bits, ones(1, r)]; 
                end
                r = 0;       
            end
        end 
        A = floor(T / 2^P);  
    end
    
    % Termination 
    if r >= 0
        encoded_bits = [encoded_bits, 0]; 
        encoded_bits = [encoded_bits, ones(1, r)]; 
    end
    
    T = bitshift(A, P) - T; 
    C = bitand(C, 2^(N+P) - 1); 
    final_bits = dec2bin(C, N+P) - '0'; 
    encoded_bits = [encoded_bits, final_bits]; 
    end
    