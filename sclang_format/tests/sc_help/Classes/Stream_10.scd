// Source: Classes/Stream.schelp block 10
(
a = Routine({ 20.do({ 33.rand.yield }) });
b = Routine({ [-100, 00, 300, 400].do({ |v| v.yield }) });

c = b.neg; // define a composite stream

// enumerate and perform all of the unary messages:
[
	\neg, \reciprocal, \bitNot, \abs, \asFloat, \asInteger, \ceil,
	\floor, \frac, \sign, \squared, \cubed, \sqrt, \exp, \midicps,
	\cpsmidi, \midiratio, \ratiomidi, \ampdb, \dbamp, \octcps,
	\cpsoct, \log, \log2, \log10, \sin, \cos, \tan, \asin, \acos, \atan,
	\sinh, \cosh, \tanh, \rand, \rand2, \linrand, \bilinrand, \sum3rand,
	\distort, \softclip, \coin, \even, \odd, \isPositive, \isNegative,
	\isStrictlyPositive
]
.do({ |msg|
	postf("\n msg: % \n", msg);
	b.reset.perform(msg).do({ |v| v.post; " ".post });
});
nil;
)
