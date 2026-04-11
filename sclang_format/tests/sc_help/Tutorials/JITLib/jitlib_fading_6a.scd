// Source: Tutorials/JITLib/jitlib_fading.schelp block 6 (part 1/6)
(
~out = { arg t_trig; EnvGen.kr(Env.asr, t_trig, doneAction: Done.freeSelf) * PinkNoise.ar([1,1]) };
)
