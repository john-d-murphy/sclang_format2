// Source: Reference/NodeProxy_roles.schelp block 3 (part 6/6)
a[0] = { |freq = 440, dt=0.1, rate=2| Ringz.ar(Dust.ar(rate * 10.dup), freq, dt)*0.1 };

a.clear(3);
