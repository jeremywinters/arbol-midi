a = 1 * 2; # should be optimized
b = a * a; # should be optimized
c = random(); # not optimized

s = [a, b];
t = s[0]; # should be optimized

u = s[c]; # not optimized

v = [a, b, c];
w = v[1]; # not optimized