// Source: Classes/Tdef.schelp block 4 (part 8/8)
(
Tdef(\a, { 10.do { |i| (" a: " + i).postln; 0.3.wait } });
Tdef(\b, { 15.do { |i| ("\t\t b: " + i).postln; 0.2.wait } });
Tdef(\c, { 5.do { |i| ("\t\t\t\t c: " + i).postln; 0.5.wait } });

Tdef(\d, {
	"fork - parallel.".postln;
	1.wait;
	Tdef(\a).fork;
	1.wait;
	Tdef(\b).fork;
	1.wait;
	Tdef(\c).fork;

	"done.".postln;
});
)
