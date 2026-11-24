// Source: Classes/SimpleNumber.schelp block 27
(-4..4).do { |val|
	(0..100).collect(_.lincurve(0, 100, 0, 1, val)).plot
}
