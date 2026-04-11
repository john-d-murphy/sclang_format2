// Source: Classes/TdefGui.schelp block 5 (part 1/12)
(
Tdef(\a, { |e| 100.do { |i| i.postln; 0.5.wait } });
t = TdefGui(Tdef(\a), 4);
Tdef(\a).set(\freq, 200, \dur, 0.1, \otto, 12, \ann, 1234);
)
