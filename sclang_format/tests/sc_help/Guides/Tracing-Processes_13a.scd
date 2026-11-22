// Source: Guides/Tracing-Processes.schelp block 13 (part 1/2)
{ SinOsc.ar(Duty.kr(0.5, 0, (Dseries(0, 1, inf) * 200 + 300).dpoll)) * 0.1 }.play;
