#!/usr/bin/env python

# Import Modules
from musicfrequency import *
import os

stl_name     = "cylinder.stl"
rate, data   = wav.read(sys.argv[1])   # read wave file data and sampling rate
track        = data.T[0]               # extrack single track from stereo wav
bit_depth    = 8.0                     # bit_depth = 16-bit signed(sonic-pi files)

normal_track = [(item/2**bit_depth)*2-1 for item in track]
data_len     = len(normal_track)

notes_count  = 13                    # 13 notes in one octave
time_slots   = 15                    # [CONFIG]: refer time_slot_count in scad file. max time slots that can be fit on a cylinder of given diameter.
pitch_multi  = 12.2                  # pitch multiplier

norm_const   = 1/((data_len/229376.0) * (rate/44000) / (time_slots/36.0))

chunk_size   = data_len/time_slots   # length of wave file by time slots available on cylinder
chunk_start  = 0
chunk_end    = chunk_start+chunk_size

freq         = []
pins         = []

fig = plt.figure()
ax  = fig.add_subplot(111)

while(chunk_end < data_len):
    fft_out      = fft(normal_track[chunk_start:chunk_end])
    fft_len      = len(fft_out)/40-1
    chunk_start += chunk_size
    chunk_end   += chunk_size
    
    temp_freq    = np.argmax(np.abs(fft_out[:fft_len]))
    
    if temp_freq!=0 and not np.isnan(temp_freq) and not temp_freq==None:
        freq.append(temp_freq)

        tinynotation += tinypitch(pitch_multi*freq[-1]*norm_const)
        pos_fft_out   = np.abs(fft_out[:fft_len])
        ax.plot(pos_fft_out)
        
        for x,y in zip(xrange(len(pos_fft_out)), pos_fft_out):
            if x == freq[-1]:
                ax.annotate('%s(%s)' % (pitch(pitch_multi*x*norm_const), x), xy=(x,y), textcoords='data')


# wav file length, music_box time slots song divided in
print "program data:"
print "data_length: ", data_len, "\tmusicbox_time_slots: ", time_slots

# compute tune from frequency time series
tune = [pitch(pitch_multi*item*norm_const) for item in freq]

# extract notes required to play tune
teethNotes = np.unique(tune)  
print "teeth      : ", len(teethNotes), "\tunique notes: ", teethNotes

# get index of pitch of minimum frequency note in tune
min_pin      = note.index(pitch(pitch_multi*np.min(freq)*norm_const)[:2])

# compute index of notes in tune
pin_index_1  = [note.index(item[:2]) for item in tune]

# correct relative note index based on octave/freq
pin_index2 = []
for item in pin_index_1:
    if item!=min_pin:
        pin_index2.append(item+min_pin+1)
    else:
        pin_index2.append(item)
        
# move notes down to lowest frequecy = 0th index on octave
pin_index = [item-min_pin for item in pin_index2]

# if total notes required less than half octave(13/2) than use the space to duplicate notes on teeth 
if len(teethNotes)<7:
    for index in xrange(len(pin_index)-1):
        if pin_index[index] == pin_index[index+1]:
            pin_index[index+1] = pin_index[index+1]+1

# display computed frequency and notes in tune
print "\ncomputed tune notes:"
print "frequency\tnotes\tpin_index"
for index in xrange(len(freq)):
    print "%1.1f\t\t%s\t%d"%(pitch_multi*freq[index]*norm_const, tune[index], pin_index[index])

for item in pin_index:
    for teeth_index in xrange(notes_count):
        if teeth_index == item:
            pins += 'X'
        else:
            pins += 'o'
pinstring =  ''.join(pins)

# display pin mapping on cylinder
print '\ncylinder notes map: '
pinstring2= ''
for counter in xrange(len(pins)):
    if counter%13==0 and counter!=0:
        pinstring2+="\n"
    pinstring2+=str(pins[counter])
print pinstring2

# if 'plot' argument passed from command line
if 'plot' in sys.argv:
    # plot fft graph(s)
    plt.grid()
    plt.show()

# if 'play' argument passed from command line
if 'play' in sys.argv:
    # import required module
    from music21 import *
    
    # play computed melody
    print tinynotation
    littleMelody = converter.parse(tinynotation)
    littleMelody.show('midi')

# if 'print' or default arguments(only song) passed from command line
if 'print' in sys.argv or len(sys.argv)==2:
    # create stl from scad and computed pin mapping from tune
    songname = sys.argv[1].split('/')[-1].split('.')[0]
    create_cylinder_command = 'openscad cylinder.scad -D \'pinNrY=' + str(len(tune)+1) + '\' -D \'MusicCylinderName="' + songname + '"\' -D \'pins="' + pinstring + '"\' -o ' + stl_name +' >/dev/null 2>&1'
    print "\ncreating stl from scad with openscad command:"
    print create_cylinder_command
    os.system(create_cylinder_command)
    print "created cylinder stl file: ", stl_name
