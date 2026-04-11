// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 21/35)
~out = { arg trig, dt=1; Decay2.kr(trig, 0.01, dt) * Mix(SinOsc.ar(7000 * [1.2, 1.3, 0.2])) }
