// Source: Tutorials/JITLib/jitlib_basic_concepts_04.schelp block 3 (part 3/8)
~x = { SinOsc.ar(800) * EnvGen.ar(Env.perc(0.001, 0.03, 0.4), doneAction: Done.freeSelf) };
