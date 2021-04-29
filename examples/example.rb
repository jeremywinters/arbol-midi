master = phasor(4000);

clock = ((master * 16) % 1) < 0.5;
x = ez_cos(master);
y = random();
z = sah(y, clock);

midi_cc(1, 1, 127 * clock);
midi_cc(1, 2, 127 * x);
midi_cc(1, 3, 127 * y);
midi_cc(1, 4, 127 * z);
