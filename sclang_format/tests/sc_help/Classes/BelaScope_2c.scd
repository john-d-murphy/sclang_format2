// Source: Classes/BelaScope.schelp block 2 (part 3/8)
{ var freq = LFNoise0.kr.range(20,2000) ! 4; SinOsc.ar(freq.belaScope(0)) }.play(~belaServer)
