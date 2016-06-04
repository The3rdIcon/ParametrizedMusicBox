#!/usr/bin/env python

# import modules
from scipy.io import wavfile as wav
import matplotlib.pyplot as plt
from scipy.fftpack import fft
import numpy as np
import sys

A4 = 440
C0 = A4*np.power(2, -4.75)        # [CONFIG]: refer C0 in scad for value

note = ["C ", "C#", "D ", "D#", "E ", "F ", "F#", "G ", "G#", "A ", "A#", "B "]  # [CONFIG]: refer teethNotes in scad for format
tinynotes = ["c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"]

tinynotation = "tinynotation: 2/8"

def pitch(freq):
    """"
    Compute pitch from frequency in scad input format

    """
    h = int(round(12*np.log2(freq/C0)))
    octave = h // 12
    n = h % 12
    return note[n] + str(octave)


def tinypitch(freq):
    """"
    Compute pitch from frequency in tinynotation format

    """
    h = int(round(12*np.log2(freq/C0)))
    octave = h // 12 - 3
    n = h % 12
    if(octave<5 and octave>-1):
        if octave == 3:
            return " " + tinynotes[n] + str(octave)
        else:
            return " " + tinynotes[n] + str(octave)
    else:
        return ""
