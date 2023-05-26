i = input(3);
f = flip_flop(i, 0.1);
g = flip_flop(f, 0.1);
h = flip_flop(g, 0.1);

midi_cc(1, 9, i * 127);
midi_cc(1, 10, f * 127 );
midi_cc(1, 11, g * 127 );
midi_cc(1, 12, h * 127 );