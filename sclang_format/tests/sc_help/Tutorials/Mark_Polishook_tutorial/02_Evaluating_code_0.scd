// Source: Tutorials/Mark_Polishook_tutorial/02_Evaluating_code.schelp block 0
{ SinOsc.ar([400, 401], 0, 0.1) * Saw.ar([11, 33], 1) * EnvGen.kr(Env.sine(10)) }.play
