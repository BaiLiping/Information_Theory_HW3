import random
import matplotlib.pyplot as plt
import math

def generate_markov1(alpha, L):
    # Initial state (assume 0 or 1 with equal probability)
    source_stream = [random.randint(0, 1)]  # Generate a random 0 or 1 as the first bit

    # Loop to generate the remaining bits in the stream
    for i in range(1, L):
        # Check the value of the previous bit (Markov-1: depends only on the previous bit)
        if source_stream[i-1] == 0:
            # 0->0 transition with probability alpha
            source_stream.append(0 if random.random() < alpha else 1)
        else:  # If the previous bit was a 1
            # 1->0 transition with probability (1-alpha)
            source_stream.append(0 if random.random() >= alpha else 1)

    # Conversion to string
    source_stream_str = ''.join(str(bit) for bit in source_stream)
    return source_stream_str

class MarkovArithmeticEncoder:
    def __init__(self, alpha):
        self.alpha = alpha  # Probability of 0 given previous 0 and 1 given previous 1
        self.low = 0.0
        self.high = 1.0
        self.state = '0'  # Initial state

    def update_range(self, symbol):
        range = self.high - self.low
        if self.state == '0':
            if symbol == '0':
                self.high = self.low + range * self.alpha
            else:
                self.low = self.low + range * self.alpha
        else:
            if symbol == '0':
                self.high = self.low + range * (1 - self.alpha)
            else:
                self.low = self.low + range * (1 - self.alpha)
        self.state = symbol  # Update state to the current symbol

    def encode(self, symbols):
        for symbol in symbols:
            self.update_range(symbol)
        return (self.low + self.high) / 2

# Function to calculate the number of bits required to represent the encoded value
def calculate_encoded_bits(encoded_value, encoder):
    # Small positive constant to avoid log domain error
    epsilon = 1e-10

    # Calculate the precision needed, ensuring the argument to log2 is positive and greater than 0
    precision = -math.log2(min(abs(encoded_value - encoder.low), abs(encoder.high - encoded_value)) + epsilon)
    return math.ceil(precision)  # Round up to the nearest whole number



# Test the encoder with different alpha values
alphas = [i / 20 for i in range(1, 20, 1)]  # Generate alphas from 0.05 to 0.95 with 0.05 interval
encoded_values = []
compression_ratios = []
L = 10000

for alpha in alphas:
    encoder = MarkovArithmeticEncoder(alpha)
    encoded_value = encoder.encode(generate_markov1(alpha, L))
    encoded_values.append((alpha, encoded_value))
    encoded_bits = calculate_encoded_bits(encoded_value,encoder)

    compression_ratios.append(L/encoded_bits)


# Plotting
plt.figure(figsize=(10, 6))
plt.plot(alphas, compression_ratios, marker='o', linestyle='-', color='b')
plt.title('Compression Ratio vs. Alpha for Markov-1 Source Stream')
plt.xlabel('Alpha')
plt.ylabel('Compression Ratio')
plt.grid(True)
plt.show()