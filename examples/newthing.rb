primary_cycle = phasor((60000/120) * 16);

primary_cycle = phasor((60000/120) * 16);

sixteenths = (primary_cycle * 64) < 0.1;

# bursts of random steps

burst_env = sah(random(), sixteenths) > 0.8);
random_bursts = sah(random(), eight_beats) > 0.8);
random_step_burst = burst_env * random_bursts;
midi_cc(1, 1, random_step_burst)