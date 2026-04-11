// Source: Tutorials/JITLib/proxyspace_examples.schelp block 12 (part 7/8)
~out = { SinOsc.ar(Rand(800, 300.0) * [1,1.1], 0, 0.1) };

~out.free(3);
