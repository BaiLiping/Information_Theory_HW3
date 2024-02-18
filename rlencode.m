function [output, start_bit] = rlencode(data)
    % RENCODE Run-length encode a string of 0s and 1s.
    %   [output, start_bit] = rlencode(data) takes a string of 0s and 1s and
    %   returns a run-length encoded version of the string. The output is a 2xn
    %   matrix, where n is the number of runs in the encoded string. The first
    %   column of the output matrix contains the run lengths, and the second column
    %   contains the data values (0 or 1). The start_bit variable is a string
    %   indicating whether the sequence starts with a 0 or a 1.

    % Error Checking (Best Practice)
    data = num2str(data); 

    % Convert input to characters for processing
    data_chars = str2num(data); 

    % Find the run lengths and data values.
    output = [];
    i = 1;
    while i <= length(data_chars)
        % Find the length of the current run.
        run_length = 1;
        while i + run_length <= length(data_chars) && data_chars(i) == data_chars(i + run_length)
            run_length = run_length + 1;
        end

        % Add the run length and data value to the output matrix.
        output = [output; run_length data_chars(i)];

        % Move to the next run.
        i = i + run_length;
    end

    % Determine the starting bit.
    start_bit = data_chars(1); 
end
