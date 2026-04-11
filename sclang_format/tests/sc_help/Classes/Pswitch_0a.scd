// Source: Classes/Pswitch.schelp block 0 (part 1/3)
(
var a, b;
a = Pseq([1, 2, 3], 2);
b = Pseq([65, 76]);
c = Pswitch([a, b, 800], Pseq([2, 2, 0, 1], inf));
x = c.asStream;
24.do({ x.next.postln; });
)
