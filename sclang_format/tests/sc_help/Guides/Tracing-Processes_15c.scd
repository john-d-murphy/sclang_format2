// Source: Guides/Tracing-Processes.schelp block 15 (part 3/3)
{ SinOsc.ar(SinOsc.ar((1..4) * 0.02, 0, 3000, 4000)).sum * 0.1 }.play;
