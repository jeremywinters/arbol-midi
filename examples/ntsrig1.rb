midi_cc(1, 43, 80 * sah(random(), phasor(100)));

gate = phasor(1000) < 0.5;

midi_note(1, 36, 127, gate);