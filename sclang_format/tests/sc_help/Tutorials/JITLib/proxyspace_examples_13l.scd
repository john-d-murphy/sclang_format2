// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 12/35)
~out = { arg freq=300, ffreq=20; SinOsc.ar(freq*[1,1.1], SinOsc.ar(ffreq, 0, pi), 0.1) };


// crossfaded setting and mapping: fadeTime is used
~out.fadeTime = 2;
