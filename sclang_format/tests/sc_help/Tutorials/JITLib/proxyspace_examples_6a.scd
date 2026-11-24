// Source: Tutorials/JITLib/proxyspace_examples.schelp block 6 (part 1/4)
~out = { SinOsc.ar([220, 330], ~out.ar(2).reverse * LFNoise2.kr(0.5, 4pi), 0.4) };
