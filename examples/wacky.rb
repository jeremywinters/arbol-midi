primary = phasor(5581); # 2 measures at 86 bpm

# clock and reset
sixteenth = (((primary * 32) % 1) < 0.5);
thirtysecond = ((primary * 64) % 1) < 0.5;
reset = primary < 0.01;

# outputs to midi
midi_cc(1, 1, 127 * primary);
midi_cc(1, 2, 127 * sixteenth);
midi_cc(1, 3, 127 * reset);
midi_cc(1, 4, 127 * thirtysecond);
midi_note(1, 60, 127, sixteenth);