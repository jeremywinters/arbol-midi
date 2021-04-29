master = phasor(1200);

x = ez_cos(master);
y = random();
z = sah(
  x, 
  (random() >= 0.99)
);
f = ((master * 16) % 16) < 0.5;

midi_cc(1, 1, 127 * x);
midi_cc(1, 2, 127 * y);
midi_cc(1, 3, 127 * z);
midi_cc(1, 4, 127 * f);
