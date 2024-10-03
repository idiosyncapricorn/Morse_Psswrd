import sounddevice as sd
import numpy as np
from audio_morse_coder import AudioAnalyzer, Morsecoder  # Combined Cython module

# Sampling frequency
freq = 44100

# Recording duration
duration = 5

# Start recorder with the given values of 
# duration and sample frequency
recording = sd.rec(int(duration * freq), 
                   samplerate=freq, channels=1)  # Set channels=1 for mono audio

# Wait for the recording to finish
sd.wait()

# Flatten the recording in case it's multi-dimensional (stereo)
if recording.ndim > 1:
    recording = recording[:, 0]  # Extract only the first channel for simplicity

# Convert the recorded audio to a NumPy array of integers (if needed)
recording = np.int16(recording * 32767)  # Convert float data to int16

# Initialize the AudioAnalyzer with the recorded audio signal
analyzer = AudioAnalyzer(recording)
frequencies = analyzer.analyze_wave()

# Initialize the Morsecoder and map frequencies to Morse code
morsecoder = Morsecoder()
morse_code = morsecoder.map_to_morse(frequencies)

# Convert the Morse code to letters
decoded_message = morsecoder.morse_to_letters(morse_code)

# Print the Morse code and the decoded message
print(f"Morse Code: {morse_code}")
print(f"Decoded Message: {decoded_message}")
