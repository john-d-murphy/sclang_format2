// Source: Classes/File.schelp block 3 (part 7/8)
(
//var f, g;
f = File("~/test.dat".standardizePath,"wb");
f.inspect;
100.do({ f.putFloat(1.0.rand); });

f.inspect;
f.close;

g = File("~/test.dat".standardizePath,"rb");
100.do({
	g.getFloat.postln;
});
g.inspect;
g.close;
)
