// Source: Classes/SimpleNumber.schelp block 29
(-4..4).do { |val|
	(0..100).collect(_.curvelin(0, 100, 0, 1, val)).plot
}
