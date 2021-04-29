master = phasor(5581); # 2 measures at 86 bpm

# clock and reset
sixteenth = (((master * 32) % 1) < 0.5);
thirtysecond = ((master * 64) % 1) < 0.5;
reset = master < 0.01;

# outputs to midi
midi_cc(1, 1, 127 * master);
midi_cc(1, 2, 127 * sixteenth);
midi_cc(1, 3, 127 * reset);
midi_cc(1, 4, 127 * thirtysecond);
midi_note(1, 60, 127, sixteenth);