// Source: Classes/UnitTestScript.schelp block 0
{ |test|
	"Kant test".postln;
	"5 + 7 = ".post;
	(5 + 7).postln;
	test.assertEquals(5 + 7, 12, "five plus seven should always be twelve");
}
