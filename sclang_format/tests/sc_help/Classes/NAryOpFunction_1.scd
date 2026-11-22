// Source: Classes/NAryOpFunction.schelp block 1
(
var a = { 1.0.rand };
var b = a.linexp(0, 1, 40, 20000);
fork {
	15.do {
		(instrument: \default, freq: b.value).play;
		0.3.wait;
	}
}
)
