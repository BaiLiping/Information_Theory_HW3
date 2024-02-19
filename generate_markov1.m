function source_stream_str = generate_markov1(alpha, L)
    % Initial state set to be 0
    source_stream(1) = 0;  

    % Loop to generate the remaining bits in the stream
    for i = 2:L  
        % Check the value of previous bit (Markov-1: depends only on the previous bit)
        if source_stream(i-1) == 0  
            % 0->1 transition with probability alpha
            if rand() < alpha 
                source_stream(i) = 1; 
            else              
                source_stream(i) = 0; 
            end
        else 
            % 1->0 transition with probability beta
            beta = alpha;
            if rand() < beta 
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
