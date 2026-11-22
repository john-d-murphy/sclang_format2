// Source: Classes/BinaryOpStream.schelp block 2
(
x = Routine { 6.do { |i| i.yield } } + Routine { (1..7).do { |i| (1 / i).yield } };
x.next.postln;
x.next.postln;
x.next.postln;
x.next.postln;
x.next.postln;
x.next.postln;
x.next.postln;
)
