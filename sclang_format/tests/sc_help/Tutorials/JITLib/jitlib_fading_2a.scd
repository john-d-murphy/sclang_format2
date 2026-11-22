// Source: Tutorials/JITLib/jitlib_fading.schelp block 2 (part 1/5)
(
~out = { arg t_trig; EnvGen.kr(Env.asr, t_trig) * PinkNoise.ar([1,1]) };
)
