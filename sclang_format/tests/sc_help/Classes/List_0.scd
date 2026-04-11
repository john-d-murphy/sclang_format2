// Source: Classes/List.schelp block 0
(
x = Array.new(3);
y = List.new(3);
5.do({ arg i; z = x.add(i); y.add(i); });
x.postln; z.postln; y.postln;
)
