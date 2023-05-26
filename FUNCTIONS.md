### + add(a, b)

### - subtract(a, b)

### * mult(a, b)

### / divide(a, b)

### % modulo(a, b)

### == equals(a, b)

### != ne(a, b)

### > gt(a, b)

### >= gtequals(a, b)

### < lt(a, b)

### pow(a, b)

### sin(a)

### cos(a)

### tan(a)

### atan(a)

### sqrt(a)

### pow(a)

### abs(a)

### exp(a)

### log(a)

### log10(a)

### round(a)      

### phasor(ms)   

* `ms` milliseconds per cycle

### midi_cc(channel, controller, value) 

* `channel` 1-16
* `controller` 0-127
* `value` 0-127

Outputs midi control change message. Subsequent values are deduplicated. 

### square(ms, pwm)   

* `channel` 1-16
* `controller` 0-127
* `value` 0-127

Outputs midi control change message. Subsequent values are deduplicated.

### millis() 

### micros() 

### pi() 

### twopi() 

### choose(choice, a, b) 

* `choice` threshold = 0.5

### between(a, lo, hi) 

### ez_sin(phase) 

* `phase` 0-1

Outputs sine calculation driven by 0-1 phase instead of radians. Output is also normalized between 0-1.

### ez_cos(phase) 

* `phase` 0-1

Outputs cosine calculation driven by 0-1 phase instead of radians. Output is also normalized between 0-1.

### random() 

Random number between 0-1

### sah(trigger, value)
* `trigger` sampling takes place when trigger transitions from < 0.5 to >=0.5
* `value` value to be sampled