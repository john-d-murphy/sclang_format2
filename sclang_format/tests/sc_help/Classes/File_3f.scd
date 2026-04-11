// Source: Classes/File.schelp block 3 (part 6/8)
(
var f, g;
f = File("~/test.txt".standardizePath,"w");
100.do({ f.putChar([$a, $b, $c, $d, $e, $\n].choose); });
f.close;

g = File("~/test.txt".standardizePath,"r");
g.readAllString.postln;
g.close;

g = File("~/test.txt".standardizePath,"r");
g.getLine(1024).postln;
"*".postln;
g.getLine(1024).postln;
"**".postln;
g.getLine(1024).postln;
"***".postln;
g.getLine(1024).postln;
"****".postln;
g.close;
)
