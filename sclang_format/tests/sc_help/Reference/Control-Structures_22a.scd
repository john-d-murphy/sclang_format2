// Source: Reference/Control-Structures.schelp block 22 (part 1/13)
(
{
	if(6 == 9, {
		var notHere;
		"hello".postln;
	},{
		"world".postln;
	})
}.def.dumpByteCodes
)
