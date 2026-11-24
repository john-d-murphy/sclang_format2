// Source: Tutorials/JITLib/proxyspace_examples.schelp block 6 (part 3/4)
~out = { SinOsc.ar(Slope.ar(~out.ar) * MouseX.kr(1000, 18000, 1)) * 0.1 + SinOsc.ar(100, 0, 0.1) };
