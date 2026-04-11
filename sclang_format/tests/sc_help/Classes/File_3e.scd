// Source: Classes/File.schelp block 3 (part 5/8)
(
var h, k;
h = File("~/test.dat".standardizePath, "wb");
h.inspect;
h.write( FloatArray[1.1, 2.2, 3.3, pi, 3.sqrt] );
h.close;

k = File("~/test.dat".standardizePath, "rb");
(k.length div: 4).do({ k.getFloat.postln; });
k.close;
)
