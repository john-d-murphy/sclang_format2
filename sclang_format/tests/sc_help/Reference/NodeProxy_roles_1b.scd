// Source: Reference/NodeProxy_roles.schelp block 1 (part 2/6)
a[0] = { |freq = 440, dt=0.1, rate=2| Ringz.ar(Impulse.ar(rate * [1, 1.2]), freq, dt)*0.1 };
