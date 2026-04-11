// Source: Classes/NodeProxy.schelp block 17 (part 5/70)
a.source = { SinOsc.ar([390, 286] * 1.2, 0, 0.2) };

// exceeding channels wrap:
a.source = { SinOsc.ar([390, 286, 400, 420, 300] * 1.2, 0, 0.2) };

// other inputs
a.source = { WhiteNoise.ar([0.01,0.01]) };
