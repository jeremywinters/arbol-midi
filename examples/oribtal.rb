base_ms = 8000;
key_square = square(80000, 0.7);
tweaker = square(100, 0.2);
base_note = choose(key_square, 23, 26);

orbit_01 = square(base_ms,         0.05);
orbit_02 = square(base_ms * 1.37,  0.05);
orbit_03 = square(base_ms * 3.73,  0.05);
orbit_04 = square(base_ms * 3.99,  0.02);
orbit_05 = square(base_ms * 5.17,  0.02);
orbit_06 = square(base_ms * 6.19,  0.02);
orbit_07 = square(base_ms * 7.99,  0.02);
orbit_08 = square(base_ms * 8.17,  0.01);
orbit_09 = square(base_ms * 11.19, 0.01);

note_01 = sah(base_note + 10, orbit_01);
note_02 = sah(base_note + 17, orbit_02);
note_03 = sah(base_note - 2,  orbit_03);
note_04 = sah(base_note + 29 + 24, orbit_04);
note_05 = sah(base_note + 33 + 24, orbit_05);
note_06 = sah(base_note + 38 + 24, orbit_06);
note_07 = sah(base_note + 29, orbit_07);
note_08 = sah(base_note + 35, orbit_08);
note_09 = sah(base_note + 48, orbit_09);

midi_note(5, note_01, 127, orbit_01);
midi_note(5, note_02, 127, orbit_02);
midi_note(5, note_03, 127, orbit_03);
midi_note(5, note_04, 127, orbit_04);
midi_note(5, note_05, 127, orbit_05);
midi_note(5, note_06, 127, orbit_06);
midi_note(2, note_07, 127, orbit_07 * choose(sah(random() + 0.25, orbit_07), 1.0, tweaker));
midi_note(2, note_08, 127, orbit_08 * choose(sah(random() + 0.25, orbit_08), 1.0, tweaker));
midi_note(2, note_09, 127, orbit_09 * choose(sah(random() + 0.25, orbit_09), 1.0, tweaker));