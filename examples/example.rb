master = phasor(4000);
master2 = phasor(9999);

clock = ((master * 64) % 1) < 0.5;
x = ez_cos(master) * clock;
y = sah(random(), clock);
z = sah(y, flip_flop(clock, 0.1));

midi_cc(1, 1, 127 * clock);
midi_cc(1, 2, 127 * x);
midi_cc(1, 3, 127 * y);
midi_cc(1, 4, 127 * z);
