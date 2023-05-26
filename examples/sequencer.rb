main_phase = fancy_phasor(960000/(86 + (input(0) * 40)), 0);
main_16th = ((main_phase * 512) % 1) < 0.5;
offset = sah(random() * 0.05, main_16th);
mpo1 = (main_phase + offset) % 1;
mp2rd = (main_phase * main_phase);
rnd = random();
primary_choices = [main_phase, mpo1 , mp2rd , rnd ];

primary = primary_choices[input(1) * 4];

I = 0;
II = 2;
III = 4;
IV = 5;
V = 7;
VI = 9;
VII = 11;

oct1 = 12;
oct2 = 24;
oct3 = 36;
oct4 = 48;
oct5 = 60;
oct6 = 72;
oct7 = 84;
oct8 = 96;

i = 0;
ii = 2;
iii = 3;
iv = 5;
v = 7;
vi = 8;
vii = 10;

measure = ((primary * 4) % 1);
twomeas = ((primary * 2) % 1);
clock = ((primary * 64) % 1) < 0.5;
thirty2 = ((primary * 128) % 1) < 0.5;
hat = ((primary * 64) % 1) < 0.5;
sixty4 = ((primary * 256) % 1) < 0.5;

r1 = choose(sah(random() > 0.96, clock), clock, sixty4);
r2 = choose(sah(random() > 0.94, clock), clock, sixty4);
r3 = choose(sah(random() > 0.90, clock), clock, sixty4);
r4 = choose(sah(random() > 0.95, clock), clock, sixty4);

# euclid_base = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  ];
# euclid_03_16 = [ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0  ];
euclid_05_16    = [ 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0  ];
euclid_06_16    = [ 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0  ];
euclid_07_16    = [ 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0  ];
euclid_09_16    = [ 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0  ];
euclid_10_16    = [ 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1  ];
euclid_11_16    = [ 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1  ];
euclid_12_16    = [ 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1  ];
euclid_13_16    = [ 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1  ];
euclid_14_16    = [ 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1  ];
euclid_15_16    = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0  ];
euclid_19_32    = [1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0];
euclid_05_02_32 = [1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0];
euclid_03_07_32 = [1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0];

kick = [ 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ];
clap = [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ];

bsnt = [ 38,38,38,38,38,38,35,40];
lead = [ 38,38,38,41,38,38,40,35];
 
ch5_measure_mask   = [ 1, 1, 1, 1, 1, 1, 0, 0];
ch6_measure_mask   = [ 0, 0, 0, 0, 0, 0, 1, 1];
perc1_measure_mask = [ 1, 1, 1, 1, 0, 0, 1, 1];
perc2_measure_mask = [ 1, 1, 0, 0, 1, 1, 0, 0];

meas_indx = measure * 16;
primary8 = primary * 8;

midi_cc(1, 1, 127 * clock * euclid_05_16[meas_indx]);
midi_cc(1, 2, 127 * clock * clap[meas_indx]);
midi_cc(1, 3, 127 * clock * euclid_07_16[meas_indx] * perc1_measure_mask[primary8]);
midi_cc(1, 4, 127 * clock * euclid_06_16[meas_indx] * perc2_measure_mask[primary8]);

midi_cc(1, 5, 127 * clock * euclid_03_07_32[twomeas * 32]);

key_offset = [-1, -1, -1, 3, -1, -6, -1, 3];

key_base = -1;

midi_note(1, bsnt[primary8] + 12 + key_base, 127, clock * euclid_13_16[meas_indx]);
midi_note(2, bsnt[primary8] - 24 + key_base, 127, clock * euclid_19_32[meas_indx]);

midi_note(5, lead[primary8] + 12 + key_base, 127, clock * euclid_05_02_32[twomeas * 32] * ch5_measure_mask[primary8]);
midi_note(6, lead[primary8]      + key_base, 127, clock * euclid_03_07_32[twomeas * 32] * ch6_measure_mask[primary8]);
