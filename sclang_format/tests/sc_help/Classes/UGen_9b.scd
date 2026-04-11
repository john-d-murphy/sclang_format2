// Source: Classes/UGen.schelp block 9 (part 2/2)
x = {SinOsc.ar((Line.kr(0, 10, 10).snap(1, 0.3, 1) + 60).poll.midicps, 0, -24.dbamp)}.play
