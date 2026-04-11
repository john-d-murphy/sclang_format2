// Source: Classes/Date.schelp block 1
(
var a = Date.seed;
thisThread.randSeed = a;
20.do { [1,0].choose.post }; "".postln;
thisThread.randSeed = a;
25.do { [1,0].choose.post }; "".postln;
)
