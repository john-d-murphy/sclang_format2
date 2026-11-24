// Source: Classes/PstepNadd.schelp block 0 (part 1/8)
(
x = PstepNadd(Pseq([1, 2, 3]), Pseq([10, 20, 30, 40]), Pseq([100, 200, 300])).asStream;
y = Pstep3add(Pseq([1, 2, 3]), Pseq([10, 20, 30, 40]), Pseq([100, 200, 300])).asStream;

50.do({ [x.next, y.next].postln });
)
