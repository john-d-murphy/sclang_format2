// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 8/38)
~out = { arg freq=100, ffreq=20; SinOsc.ar(freq, SinOsc.ar(SinOsc.ar(ffreq)*ffreq, 0, pi), 0.2) };
