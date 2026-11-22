// Source: Tutorials/JITLib/jitlib_fading.schelp block 3 (part 1/2)
~out = { arg gate=1; EnvGen.kr(Env.asr, gate, doneAction: Done.freeSelf) * 0.2 * SinOsc.ar([1,1]*Rand(440,550)) };
