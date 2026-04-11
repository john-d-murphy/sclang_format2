// Source: Classes/TdefAllGui.schelp block 0 (part 1/8)
(
Tdef(\a, { |e| 100.do { |i| i.postln; 0.5.wait } });
Tdef(\b, { |e| 100.do { |i| Tdef(\a).set(\otto, 8.rand); exprand(0.1, 3.0).wait } });
t = TdefAllGui(8);
)
