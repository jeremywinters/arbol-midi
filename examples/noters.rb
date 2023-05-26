C = 0;
Csharp = 1;
D = 2;
Dsharp = 3;
E = 4;
F = 5;
Fsharp = 6;
G = 7;
Gsharp = 8;
A = 9;
Asharp = 10;
B = 11;

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

keys = [C, Csharp, D, Dsharp, E, F, Fsharp, G, Gsharp, A, Asharp, B];

pattern = input(0);
ratchet_select = input(2);
reset   = input(3);
ratchet = input(4);
not_ratchet = abs(ratchet - 1);
freezer = input(5);

bpm = 86;
ms_per_beat = 60000 / bpm;
sixteen_measures = fancy_phasor(16 * 4 * ms_per_beat, reset);
one_measure  = (sixteen_measures * 16) % 1;
two_measure  = (sixteen_measures * 8) % 1;
four_measure = (sixteen_measures * 4) % 1;

one_measure_reset = one_measure < 0.2;

quarters   = ((sixteen_measures * 64 ) % 1) < 0.5;
eighths    = ((sixteen_measures * 128) % 1) < 0.5;
sixteenths = ((sixteen_measures * 256) % 1) < 0.5;
thirty2nds = ((sixteen_measures * 512) % 1) < 0.5;
sixty4ths  = ((sixteen_measures * 1024) % 1) < 0.5;
one28ths   = ((sixteen_measures * 2048) % 1) < 0.5;

pat0_beats_00 = [ 1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0 ];
pat0_beats_01 = [ 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 1, 1 ];
pat0_beats_02 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat0_beats_03 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 1, 1 ];
pat0_beats_04 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat0_beats_05 = [ 1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1 ];
pat0_notes_01 = [ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii ];
pat0_notes_02 = [ v + 12,v,v,v + 12, ii,ii,ii + 12,ii, ii,v + 12,v,v, v + 12,v,iii,iii + 12, v,v,v + 12,v, ii,ii + 12,ii,ii, ii + 12,v,v,v + 12, v,v,iii + 12,iii ];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                           
pat1_beats_00 = [ 1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0 ];
pat1_beats_01 = [ 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 1, 1 ];
pat1_beats_02 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat1_beats_03 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 1, 1 ];
pat1_beats_04 = [ 1, 0, 0, 0,  0, 0, 1, 0,  1, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat1_beats_05 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1 ];
pat1_notes_01 = [ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii, ii,ii,ii,ii ];
pat1_notes_02 = [ v + 12,v,v,v + 12, ii,ii,ii + 12,ii, ii,v + 12,v,v, v + 12,v,iii,iii + 12, v,v,v + 12,v, ii,ii + 12,ii,ii, ii + 12,v,v,v + 12, v,v,iii + 12,iii ];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                             
pat2_beats_00 = [ 1, 1, 0, 1,  0, 0, 1, 1,  0, 1, 0, 0,  1, 0, 1, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat2_beats_01 = [ 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 1, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat2_beats_02 = [ 0, 0, 1, 1,  0, 1, 1, 0,  1, 1, 1, 1,  1, 0, 0, 1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat2_beats_03 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat2_beats_04 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0,  1, 0, 0, 1,  0, 1, 0, 0 ];
pat2_beats_05 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat2_notes_01 = [iii,iii,iii,iii, iii,iii,iii,iii, iii,iii,iii,iii, iii,iii,iii,iii, iii,iii,iii,iii, iii,iii,iii,iii, iii,iii,iii,iii, iii,iii,iii,iii ];
pat2_notes_02 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
                                                                                                             
pat3_beats_00 = [ 1, 0, 0, 1,  0, 0, 0, 0,  1, 0, 0, 1,  0, 0, 0, 0,  1, 0, 0, 1,  0, 0, 0, 0,  1, 0, 0, 1,  0, 0, 0, 0 ];
pat3_beats_01 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0 ];
pat3_beats_02 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat3_beats_03 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat3_beats_04 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat3_beats_05 = [ 1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1 ];
pat3_notes_01 = [ 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 ];
pat3_notes_02 = [ v,v,v,v, ii,ii,ii,ii, ii,v,v,v, v,v,iii,iii, v,v,v,v, ii,ii,ii,ii, ii,v,v,v, v,v,iii,iii ];

one_measure_indx = one_measure * 16;
two_measure_indx = two_measure * 32;
four_measure_indx = four_measure * 64;

beats_00 = [
  pat0_beats_00[two_measure_indx],
  pat1_beats_00[two_measure_indx],
  pat2_beats_00[two_measure_indx],
  pat3_beats_00[two_measure_indx]
];

beats_01 = [
  pat0_beats_01[two_measure_indx],
  pat1_beats_01[two_measure_indx],
  pat2_beats_01[two_measure_indx],
  pat3_beats_01[two_measure_indx]
];

beats_02 = [
  pat0_beats_02[two_measure_indx],
  pat1_beats_02[two_measure_indx],
  pat2_beats_02[two_measure_indx],
  pat3_beats_02[two_measure_indx]
];

beats_03 = [
  pat0_beats_03[two_measure_indx], 
  pat1_beats_03[two_measure_indx], 
  pat2_beats_03[two_measure_indx], 
  pat3_beats_03[two_measure_indx]
];

beats_04 = [
  pat0_beats_04[two_measure_indx], 
  pat1_beats_04[two_measure_indx], 
  pat2_beats_04[two_measure_indx], 
  pat3_beats_04[two_measure_indx]
];

beats_05 = [
  pat0_beats_05[two_measure_indx], 
  pat1_beats_05[two_measure_indx], 
  pat2_beats_05[two_measure_indx], 
  pat3_beats_05[two_measure_indx]
];

key = Csharp + 12;
notes_01 = [
  pat0_notes_01[two_measure_indx] + key, 
  pat1_notes_01[two_measure_indx] + key, 
  pat2_notes_01[two_measure_indx] + key, 
  pat3_notes_01[two_measure_indx] + key
];


notes_02 = [
  pat0_notes_02[two_measure_indx] + key, 
  pat1_notes_02[two_measure_indx] + key, 
  pat2_notes_02[two_measure_indx] + key, 
  pat3_notes_02[two_measure_indx] + key
];

pattern_indx = sah(pattern * 4, one_measure_reset);

# pick beat patterns based on sah
beats_00_select = pattern_indx;
beats_01_select = pattern_indx;
beats_02_select = pattern_indx;
beats_03_select = pattern_indx;
beats_04_select = pattern_indx;
beats_05_select = pattern_indx;

beat00 = beats_00[beats_00_select] * sixteenths;
beat01 = beats_01[beats_01_select] * sixteenths;
beat02 = beats_02[beats_02_select] * sixteenths;
beat03 = beats_03[beats_03_select] * sixteenths;
beat04 = beats_04[beats_04_select] * sixteenths;
beat05 = beats_05[beats_05_select] * thirty2nds;

note01 = notes_01[pattern_indx];
note02 = notes_02[pattern_indx];

# ratchets

ratchet_indx = ratchet_select * 5;

beat00_ratchet = [
  sixteenths,
  eighths,
  sixteenths,
  0,
  0
];

beat01_ratchet = [
  0,
  eighths,
  sixteenths,
  0,
  eighths
];

beat02_ratchet = [
  0,
  0,
  0,
  sixteenths,
  sixteenths
];

beat03_ratchet = [
  0,
  0,
  0,
  eighths,
  0
];

# ratchets for only beat
actual_beat00 = choose(ratchet, beat00, beat00_ratchet[ratchet_indx]);
actual_beat01 = choose(ratchet, beat01, beat01_ratchet[ratchet_indx]);
actual_beat02 = choose(ratchet, beat02, beat02_ratchet[ratchet_indx]);
actual_beat03 = choose(ratchet, beat03, beat03_ratchet[ratchet_indx]);
actual_beat04 = beat04 * not_ratchet; # choose(ratchet, beat04, current_ratchet);
actual_beat05 = choose(ratchet, beat05, 0);

beat_warp_cc = ez_cos(phasor(2300));

midi_cc(1, 1, 127 * actual_beat00);
midi_cc(1, 2, 127 * actual_beat01);
midi_cc(1, 3, 127 * actual_beat02);
midi_cc(1, 4, 127 * actual_beat03);
midi_cc(1, 5, 127 * beat_warp_cc * ratchet);

# measure reset
midi_cc(1, 6, 127 * (one_measure < 0.05));

scrubber = (((sixteen_measures * 48)) % 1) * 0.4 + (phasor(10000) * 0.6);

midi_cc(1, 7, 127 * scrubber);

# bass
midi_note(6, note01, 127, actual_beat04);

# odessa
midi_note(1, note02, 127, actual_beat05);
