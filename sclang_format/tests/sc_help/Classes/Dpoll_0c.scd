// Source: Classes/Dpoll.schelp block 0 (part 3/8)
{ LFPulse.ar(Duty.kr(0.5, 0, Dpoll(Dseries(0, 1, inf) % 10 + 1 * 30, "value"))) * 0.1 }.play;
