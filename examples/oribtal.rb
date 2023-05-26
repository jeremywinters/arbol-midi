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

key = keys[input(0) * 12];
base_ms = (input(1) * 30000) + 1000;
# base_ms = 6000;
var_ms = (60000 * input(2));
gate = 0.03;

curve_exponent = 0.6;

mode = flip_flop(input(3), 0.1);
reset_phasors = input(4);
enable_accents = flip_flop(input(5), 0.1);

notes_tense = [
  key + II + oct1,
  key + VI + oct2, 
  key + oct2, 
  
  key + VI + oct4, 
  key + II + oct6, 
  key + VI + oct6,
  
  key + oct2, 
  key + VI + oct2, 
  key + II + oct2,
  
  key + oct1, 
  key + II + oct1, 
  key + V + oct1,
  
  key + oct2, 
  key + VI + oct2, 
  key + II + oct2
];

notes_resolved = [
  key + III + oct2,
  key + V + oct1, 
  key + oct2, 
  
  key + V + oct6, 
  key + III + oct6, 
  key + IV + oct6,
  
  key + oct2, 
  key + V + oct2, 
  key + V + oct3,
  
  key + oct1, 
  key + VII + oct1, 
  key + IV + oct2,
  
  key + oct2, 
  key + V + oct2, 
  key + V + oct2
];

notes = [
  choose(mode, notes_tense[0], notes_resolved[0]),
  choose(mode, notes_tense[1], notes_resolved[1]),
  choose(mode, notes_tense[2], notes_resolved[2]),
  
  choose(mode, notes_tense[3], notes_resolved[3]),
  choose(mode, notes_tense[4], notes_resolved[4]),
  choose(mode, notes_tense[5], notes_resolved[5]),

  choose(mode, notes_tense[6], notes_resolved[6]),
  choose(mode, notes_tense[7], notes_resolved[7]),
  choose(mode, notes_tense[8], notes_resolved[8]),
  
  choose(mode, notes_tense[9], notes_resolved[9]),
  choose(mode, notes_tense[10], notes_resolved[10]),
  choose(mode, notes_tense[11], notes_resolved[11]),
  
  choose(mode, notes_tense[12], notes_resolved[12]),
  choose(mode, notes_tense[13], notes_resolved[13]),
  choose(mode, notes_tense[14], notes_resolved[14])
];


phase_scale = [
  0,
  pow(0.1, curve_exponent),
  pow(0.26, curve_exponent),
  
  pow(0.3, curve_exponent),
  pow(0.4, curve_exponent),
  pow(0.5, curve_exponent),
  
  pow(0.6, curve_exponent),
  pow(0.7, curve_exponent),
  pow(0.8, curve_exponent),

  pow(0.04, curve_exponent),
  pow(0.05711, curve_exponent),
  pow(0.079, curve_exponent),

  pow(0.82, curve_exponent),
  pow(0.9, curve_exponent),
  pow(1.0, curve_exponent)
];

phases = [
  base_ms + (phase_scale[0] * var_ms), 
  base_ms + (phase_scale[1] * var_ms), 
  base_ms + (phase_scale[2] * var_ms), 
  base_ms + (phase_scale[3] * var_ms), 
  base_ms + (phase_scale[4] * var_ms), 
  base_ms + (phase_scale[5] * var_ms), 
  
  base_ms + (phase_scale[6] * var_ms), 
  base_ms + (phase_scale[7] * var_ms), 
  base_ms + (phase_scale[8] * var_ms),
  
  base_ms + (phase_scale[9] * var_ms), 
  base_ms + (phase_scale[10] * var_ms), 
  base_ms + (phase_scale[11] * var_ms),

  base_ms + (phase_scale[12] * var_ms), 
  base_ms + (phase_scale[13] * var_ms), 
  base_ms + (phase_scale[14] * var_ms)
];

midi_note(1, notes[0], 127, fancy_phasor(phases[0], reset_phasors) < gate);
midi_note(1, notes[1], 127, fancy_phasor(phases[1], reset_phasors) < gate);
midi_note(1, notes[2], 127, fancy_phasor(phases[2], reset_phasors) < gate);

midi_note(1, notes[3], 127, fancy_phasor(phases[3], reset_phasors) < gate);
midi_note(1, notes[4], 127, fancy_phasor(phases[4], reset_phasors) < gate);
midi_note(1, notes[5], 127, fancy_phasor(phases[5], reset_phasors) < gate);
                     
midi_note(1, notes[6], 127, fancy_phasor(phases[6], reset_phasors) < gate);
midi_note(1, notes[7], 127, fancy_phasor(phases[7], reset_phasors) < gate);
midi_note(1, notes[8], 127, fancy_phasor(phases[8], reset_phasors) < gate);

midi_note(1, notes[9], 127, (fancy_phasor(phases[9], reset_phasors) < gate) * enable_accents);
midi_note(1, notes[10], 127, (fancy_phasor(phases[10], reset_phasors) < gate) * enable_accents);
midi_note(1, notes[11], 127, (fancy_phasor(phases[11], reset_phasors) < gate) * enable_accents);

midi_note(4, notes[12], 127, fancy_phasor(phases[12], reset_phasors) < gate);
midi_note(4, notes[13], 127, fancy_phasor(phases[13], reset_phasors) < gate);
midi_note(4, notes[14], 127, fancy_phasor(phases[14], reset_phasors) < gate);

midi_cc(1, 1, (phasor(2000) < 0.5 ) * 127 );