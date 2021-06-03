master = phasor(4000);

clock = ((master * 16) % 1) < 0.5;
sixty4 = ((master * 64) % 1) < 0.5;

r1 = choose(random() > 0.98, clock, sixty4);
r2 = choose(random() > 0.97, clock, sixty4);

kick = [ 1, 0, 0, 0, 1, 0, 0, 0, 0,r1, 0, 0, 1, 0, 0, 0 ];
clap = [ 0, 0, 0, 0,r2, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ];

midi_cc(1, 1, 127 * clock * kick[master * 16]);
midi_cc(1, 2, 127 * clock * clap[master * 16]);