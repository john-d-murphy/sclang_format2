// Source: Classes/BinaryOpFunction.schelp block 1
(
var a = { 19.rand };
var b = { [5, 8, 9].choose };
var c = a + b;
fork {
	15.do {
		(instrument: \default, note: [c.value, a.value]).play;
		0.3.wait;
	}
}
)
