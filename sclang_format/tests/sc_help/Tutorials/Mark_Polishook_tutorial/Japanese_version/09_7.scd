// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 7
{ SinOsc.ar(440, 0, 0.1) * EnvGen.kr(Env.sine(1), doneAction: Done.freeSelf) }.scope;
