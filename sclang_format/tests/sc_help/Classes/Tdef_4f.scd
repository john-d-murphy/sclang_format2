// Source: Classes/Tdef.schelp block 4 (part 6/8)
(
Tdef(\a, { 10.do { |i| (" a: " + i).postln; 0.3.wait } });
Tdef(\b, { 15.do { |i| ("\t\t b: " + i).postln; 0.2.wait } });
Tdef(\c, { 5.do { |i| ("\t\t\t\t c: " + i).postln; 0.5.wait } });

Tdef(\d, {
	"embed - sequence.".postln;
	1.wait;
	Tdef(\a).embed;
	1.wait;
	Tdef(\b).embed;
	1.wait;
	Tdef(\c).embed;

	"done.".postln;
});
)
