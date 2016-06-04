"""PyAudio Example: Play a WAVE file.
URL: https://people.csail.mit.edu/hubert/pyaudio/
Reads wav stream using wave module and outputs using pyaudio module
"""

import pyaudio
import wave
import sys
import struct

CHUNK = 1024

if len(sys.argv) < 2:
    print("Plays a wave file.\n\nUsage: %s filename.wav" % sys.argv[0])
    sys.exit(-1)

wf = wave.open(sys.argv[1], 'rb')
swidth = wf.getsampwidth()
frate  = wf.getframerate()
p = pyaudio.PyAudio()

stream = p.open(format=p.get_format_from_width(wf.getsampwidth()),
                channels=wf.getnchannels(),
                rate=wf.getframerate(),
                output=True)

data = wf.readframes(CHUNK)

while data != '':
    stream.write(data)
    #sample_buff = struct.unpack("%dh"%(len(data)/swidth), data)
    data = wf.readframes(CHUNK)

stream.stop_stream()
stream.close()

p.terminate()
