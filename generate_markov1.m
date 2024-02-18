function source_stream = generate_markov1(alpha, L)
    % Generates a Markov-1 character string of 0s and 1s
    %
    % Inputs:
    %   alpha: Transition probability
    %   L:     Length of the desired source stream
    %
    % Output:
    %   source_stream: Binary source stream (array of 0s and 1s)

    % Initial state (assume 0 or 1 with equal probability)
    source_stream(1) = randi([0, 1]);  % Generate a random 0 or 1 as the first bit

    % Loop to generate the remaining bits in the stream
    for i = 2:L  
        % Check the value of previous bit (Markov-1: depends only on the previous bit)
        if source_stream(i-1) == 0  
            % 0->0 transition with probability alpha
            if rand() < alpha 
                source_stream(i) = 0; 
            else              
                source_stream(i) = 1; 
            end
        else  % If the previous bit was a 1
            % 1->0 transition with probability (1-alpha)
            if rand() >= alpha 
                source_stream(i) = 0;
            else             
                source_stream(i) = 1;
            end
        end
    end    
end
