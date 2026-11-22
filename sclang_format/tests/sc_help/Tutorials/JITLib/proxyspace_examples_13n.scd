// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 14/38)
~out = { arg freq=300, ffreq=20; SinOsc.ar(freq*[1,1.1], SinOsc.ar(ffreq, 0, pi), 0.1) };
