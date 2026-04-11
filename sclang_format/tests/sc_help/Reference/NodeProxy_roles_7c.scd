// Source: Reference/NodeProxy_roles.schelp block 7 (part 3/5)
a[1] = \filterIn -> { |in| CombL.ar(in, 0.2, LFNoise2.kr(0.5!2).exprange(0.01, 0.2), 3) };


a.set(\wet1, 0.5);
