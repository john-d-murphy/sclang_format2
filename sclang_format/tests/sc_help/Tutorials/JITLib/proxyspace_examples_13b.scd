// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 2/35)
~out = { arg freq=500, ffreq=120; SinOsc.ar(freq*[1,1.1], SinOsc.ar(ffreq, 0, pi), 0.2) };
