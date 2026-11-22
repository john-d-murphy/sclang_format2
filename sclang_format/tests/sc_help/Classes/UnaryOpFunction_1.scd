// Source: Classes/UnaryOpFunction.schelp block 1
(
var a = { 19.rand };
var b = a.sqrt;
fork {
	15.do {
		(instrument: \default, note: [a.value, b.value]).play;
		0.3.wait;
	}
}
)
