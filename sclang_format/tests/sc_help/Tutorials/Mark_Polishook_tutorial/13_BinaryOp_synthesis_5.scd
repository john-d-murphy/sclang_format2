// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 5
{ SinOsc.ar(440, 0, 0.1) * EnvGen.kr(Env.sine(1), doneAction: Done.freeSelf) }.scope;
