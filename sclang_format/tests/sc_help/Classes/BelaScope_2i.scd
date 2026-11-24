// Source: Classes/BelaScope.schelp block 2 (part 9/9)
{ SinOsc.ar(LFNoise0.ar([1, 2, 3]).exprange(20, 20000)) * LFNoise1.ar([1, 2, 3]).exprange(0.001, 0.1) }.belaScope(4, ~belaServer)
