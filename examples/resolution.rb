i = 0;
ii = 2;

iii = 4;
iv = 5;

v = 7;
vi = 9;

vii = 11;

tk1_seq1 = [  vi,  ii,  v,  iv, iii, vii,   i];

base = 36;
meas = phasor(2000);
beat = ((meas * 4) % 1) < 0.8;

midi_note(1, tk1_seq1[meas * 7], 127, beat);