// Source: Tutorials/JITLib/jitlib_fading.schelp block 2 (part 3/5)
(
~out = { arg t_trig; EnvGen.kr(Env.asr, t_trig) * SinOsc.ar([1,1]*400) };
)
