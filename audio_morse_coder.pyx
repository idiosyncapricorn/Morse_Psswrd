# audio_morse_coder.pyx
import wave
import numpy as np
from scipy.fftpack import fft

cdef class AudioAnalyzer:
    cdef object signal  # Store the audio signal for processing

    def __init__(self, signal):
        self.signal = signal

    def analyze_wave(self):
        """
        Perform FFT on the provided audio signal and extract frequencies.
        """
        # Perform FFT on the signal (consider using only part of the signal)
        fft_out = fft(self.signal)
        frequencies = np.abs(fft_out)[:len(fft_out) // 2]  # Only use half of the FFT result
        return frequencies

cdef class Morsecoder:
    cdef dict morse_mapping

    def __init__(self):
        self.morse_mapping = {
            ".-": "A", "-...": "B", "-.-.": "C", "-..": "D", ".": "E",
            "..-.": "F", "--.": "G", "....": "H", "..": "I", ".---": "J",
            "-.-": "K", ".-..": "L", "--": "M", "-.": "N", "---": "O",
            ".--.": "P", "--.-": "Q", ".-.": "R", "...": "S", "-": "T",
            "..-": "U", "...-": "V", ".--": "W", "-..-": "X", "-.--": "Y",
            "--..": "Z"
        }

    def map_to_morse(self, frequencies):
        """
        Convert frequencies to Morse code (dots, dashes, and spaces).
        """
        morse_code = []
        for f in frequencies:
            if f > 5000:  # High frequency represents a dot
                morse_code.append('.')
            elif f > 2000:  # Lower frequency represents a dash
                morse_code.append('-')
            else:
                morse_code.append(' ')  # Space or pause
        return ''.join(morse_code)

    def morse_to_letters(self, morse_code):
        """
        Convert Morse code to letters using the morse_mapping.
        """
        letters = []
        for code in morse_code.split():
            if code in self.morse_mapping:
                letters.append(self.morse_mapping[code])
        return ''.join(letters)
