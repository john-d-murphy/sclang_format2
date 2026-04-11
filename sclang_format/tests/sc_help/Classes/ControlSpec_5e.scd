// Source: Classes/ControlSpec.schelp block 5 (part 5/5)
(
var invals = (0..10).normalize;
(-4..4).do { |curve|
	var a = [0, 1, curve].asSpec;
	a.map(invals).plot;
}
);
