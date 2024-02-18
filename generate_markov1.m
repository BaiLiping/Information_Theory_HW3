function source_stream_str = generate_markov1(alpha, L)
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
    % Conversion to string
    source_stream_str = '';  % Initialize an empty string
    for i = 1:length(source_stream)
        source_stream_str = [source_stream_str char(source_stream(i) + '0')]; 
    end    
    
end
