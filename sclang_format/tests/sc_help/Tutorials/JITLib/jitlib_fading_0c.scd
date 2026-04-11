// Source: Tutorials/JITLib/jitlib_fading.schelp block 0 (part 3/7)
d = ProxySynthDef("test", { arg freq=440; SinOsc.ar(freq) }).send(s);
