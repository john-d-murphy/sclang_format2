// Source: Guides/Level_Compensation.schelp block 1 (part 12/15)
{ SinOsc.ar({ rrand(100.0, 1000.0).postln }! n, 0.5pi).sum / n }.play;
