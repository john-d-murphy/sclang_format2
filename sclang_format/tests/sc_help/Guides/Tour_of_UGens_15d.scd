// Source: Guides/Tour_of_UGens.schelp block 15 (part 4/4)
{ RLPF.ar(Pulse.ar([100,250],0.5,0.1), XLine.kr(8000,400,5), 0.05) }.scope(1);
