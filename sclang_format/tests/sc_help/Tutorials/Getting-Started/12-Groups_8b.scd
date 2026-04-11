// Source: Tutorials/Getting-Started/12-Groups.schelp block 8 (part 2/4)
4.do({ { arg amp = 0.1; Pan2.ar(SinOsc.ar(440 + 110.rand, 0, amp), 1.0.rand2) }.play(g); });
