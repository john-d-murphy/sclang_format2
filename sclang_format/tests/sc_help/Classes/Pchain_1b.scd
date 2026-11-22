// Source: Classes/Pchain.schelp block 1 (part 2/9)
(
a = Pbind(\degree, Pseq([1, 2, 3], inf), \dur, Prand([0.2, 0.4], inf));
b = Pbind(\detune, Pseq([-30, 0, [0, 40]], inf), \dur, 0.1);
c = b <> a;
c.play; // see that the \dur key of a is overridden by b
)
