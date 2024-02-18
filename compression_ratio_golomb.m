function compression_ratio = compression_ratio_golomb(run_lengths, k)
    """
    Calculates the compression ratio of a sequence of run-lengths using Golomb-Rice coding.
  
    Args:
      run_lengths: A list of non-negative integers representing run lengths.
      k: The Golomb parameter (a positive integer).
  
    Returns:
      The compression ratio as a float.
    """
  
    if k <= 0
      error("Golomb parameter k must be positive.");
    end
  
    original_size = sum(run_lengths); % Size of the original data
  
    % Golomb-Rice encoding:
    quotients = floor(run_lengths / k);
    remainders = mod(run_lengths, k);
  
    % Unary encoding of quotients (size in bits)
    unary_encoded_lengths = quotients + 1; 
  
    % Truncated binary encoding of remainders (size in bits)
    remainder_encoded_lengths = ceil(log2(k)); 
  
    % Calculate total encoded size in bits
    encoded_size = sum(unary_encoded_lengths) + sum(remainder_encoded_lengths);
  
    % Calculate compression ratio
    compression_ratio = original_size / encoded_size;
  end
  