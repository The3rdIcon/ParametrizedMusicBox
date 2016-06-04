import midi
import sys

# Preprinted comb mapping.
# This is an entire octave and should be fine for our purposes.
printedMapping = [
    "C 4",
    "C#4",
    "D 4",
    "D#4",
    "E 4",
    "F 4",
    "F#4",
    "G 4",
    "G#4",
    "A 4",
    "A#4",
    "B 4",
    "C 5",
    "C#5",
    "D 5",
    "D#5",
    "E 5",
    "F 5"
]

# Pairs of notes that are equivalent to one another
equivPairs = [
    ("Db", "C#"),
    ("Eb", "D#"),
    ("Gb", "F#"),
    ("Ab", "G#"),
    ("Bb", "A#")
]

# Returns a new note that is in our mapping from a note that is not.
# for example passing "Db" would return "C#"
def equalPitch(a):
    note = a[0:2]
    octave = a[2]
    for i in range(0, len(equivPairs)):
        pair = equivPairs[i]
        if pair[0] == note:
            return pair[1] + octave
        elif pair[1] == note:
            return pair[1]
        else:
            continue
    return note + a[2]

# We want to get a mapping of midi note numbers to the actual note
# names. for example 42 -> A/ NOTE_NAME_MAP_FLAT contains the mapping
# but in opposite order.
pitches = {}

for pair in midi.NOTE_NAME_MAP_FLAT.items():
    pitches[pair[1]] = pair[0]

# Returns the properly formatted note string for the scad file.
def formatNote(note):
    if len(note) == 3:
        newNote = equalPitch(note.replace("_", " ", -1))[0:2] + "4"
        return newNote
    else:
        return equalPitch(note.replace("_", "", -1))[0:2] + "4"

# Returns an empty row filled with amount spaces.
# This should be the number of notes on the comb.
def emptyRow(amount):
    return ['o'] * amount

# Returns the track for the song
def getTrack(song, which):
    return song[which]

# We want to get the unique list of notes so we add a set
# because the music box cannot keep notes held we worry about
# only when that note is first seen.
def uniqueNotes(track):
    notes = set()
    for event in track:
        if isinstance(event, midi.NoteOnEvent):
            number = event.get_pitch()
            pitch = pitches[number]
            notes.add(pitch)
    return notes

# This is used to compare note ordering
NOTE_ORDER = ['C', 'D', 'E', 'F', 'G', 'A', 'B']
def pitch_cmp(a, b):
    indA = NOTE_ORDER.index(a)
    indB = NOTE_ORDER.index(b)
    if indA == indB:
        return 0
    elif indA < indB:
        return -1
    else:
        return 1

# Compares both the pitch and the octave to see which note comes before which
# note
def note_cmp(a, b):
    if a[2] == b[2]:
        return pitch_cmp(a[0], b[0])
        return 0
    elif a[2] < b[2]:
        return -1
    else:
        return 1
    return -1

def main():
    params = sys.argv
    if len(params) < 3:
        print "Please provide file name and track number"
        return

    midiFile = params[1]
    trackNumber = params[2]

    # the song we're going to be using
    song = midi.read_midifile(midiFile)
    track = getTrack(song, int(trackNumber))

    nameEvent = None
    for event in track:
        if isinstance(event, midi.TrackNameEvent):
            nameEvent = event

    if nameEvent is not None:
        print "Using track:", nameEvent.text
    else:
        print "Could not find name of track"

    # Set the tick position to be absolute instead of relative to the tick
    # before it. So instead of tick = 1, tick = 1, tick = 1 we get tick = 1,
    # tick = 2, tick = 3;
    track.make_ticks_abs()
    notes = uniqueNotes(track)


    # The cylinder expects the notes in a different format than the
    # midi library gives it to us.
    formattedNotes = []
    for note in notes:
        formattedNotes.append(formatNote(note))

    # The notes don't really have to be sorted but it looks better
    # on the comb.
    formattedNotes.sort(note_cmp)

    rowNotes = {}
    nextTick = 0
    for event in track:
        if isinstance(event, midi.NoteOnEvent):
            if (event.tick not in rowNotes):
                rowNotes[event.tick] = [event]
                nextTick += 512
            else:
                rowNotes[event.tick].append(event)

    finalString = ""
    timeSlots = 0
    keys = rowNotes.keys()
    keys.sort()

    for index in range(0, len(keys)):
        tick = keys[index]

        # Set all the row position to empty
        row = emptyRow(len(printedMapping))
        for note in rowNotes[tick]:
            # Get the position of the note on the comb.
            noteCombIndex = printedMapping.index(formatNote(pitches[note.get_pitch()]))
            # Set that position to the character X
            row[noteCombIndex] = 'X'
            # append the row to the string
            finalString += ''.join(row)
        timeSlots += 1
        print ''.join(row).replace('X', '_').replace('o', '*')

    print
    print finalString
    print
    print ''.join(printedMapping)
    print
    print "Timeslots:", timeSlots

print
main()
