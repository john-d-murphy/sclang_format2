// Source: Classes/PdefAllGui.schelp block 0 (part 1/9)
(
Pdef(\a, { |e| 100.do { |i| i.postln; 0.5.wait } });
Pdef(\b, { |e| 100.do { |i| Pdef(\a).set(\otto, 8.rand); exprand(0.1, 3.0).wait } });
t = PdefAllGui(8);
)
