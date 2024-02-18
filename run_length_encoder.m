function [run_lengths, start_bit] = run_length_encode(binary_sequence)
    % Validates input to ensure it's a character array (string) 
    if ~ischar(binary_sequence)
        error('Input binary_sequence must be a character array (string).');
    end

    % Initialization
    current_char = binary_sequence(1);
    start_bit = str2double(current_char); % Convert character '0' or '1' to numerical value
    run_lengths = [];
    current_run_length = 1;

    % Iteration and Encoding
    for i = 2:length(binary_sequence)
        if binary_sequence(i) == current_char
            current_run_length = current_run_length + 1;
        else
            run_lengths = [run_lengths, current_run_length];
            current_char = binary_sequence(i);
            current_run_length = 1;
        end
    end

    % Append the length of the last run
    run_lengths = [run_lengths, current_run_length];
end
