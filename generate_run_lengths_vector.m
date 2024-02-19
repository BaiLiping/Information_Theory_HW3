function [run_lengths_vector, unique_lengths,pmf] = generate_run_lengths_vector(binary_sequence)
    % Initialization
    current_char = binary_sequence(1);
    run_lengths_vector = [];
    current_run_length = 1;

    % Iteration and Encoding
    for i = 2:length(binary_sequence)
        if binary_sequence(i) == current_char
            current_run_length = current_run_length + 1;
        else
            run_lengths_vector = [run_lengths_vector, current_run_length];
            current_char = binary_sequence(i);
            current_run_length = 1;
        end
    end
    run_lengths_vector = [run_lengths_vector, current_run_length];
    unique_lengths = unique(run_lengths_vector);
    pmf = histc(run_lengths_vector, unique_lengths);
    frequencies = pmf / length(run_lengths_vector);
end
