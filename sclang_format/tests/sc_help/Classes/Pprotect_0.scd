// Source: Classes/Pprotect.schelp block 0
(
var x;
var func = { "an error happened".postln };
a = Pprotect(Pseq([1, 3, 3, Pfuncn({ Error.new.throw }), 2]), func);
x = Pbind(\degree, a, \dur, 0.5).play;
)
