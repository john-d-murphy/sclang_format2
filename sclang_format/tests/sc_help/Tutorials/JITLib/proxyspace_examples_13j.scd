// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 10/35)
~out = { arg freq=300, ffreq=20; Pulse.ar(freq * [1, 1.1] + SinOsc.ar(ffreq, 0, freq), 0.3, 0.1) };
