// Source: Guides/Multichannel-Expansion.schelp block 6
{ RLPF.ar(Saw.ar([100,250],0.05), XLine.kr([8000,500],[400,7000],5), 0.05) }.play;
