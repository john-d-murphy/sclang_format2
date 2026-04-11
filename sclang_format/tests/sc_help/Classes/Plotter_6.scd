// Source: Classes/Plotter.schelp block 6
(
var plotter = [10, 34, 167].collect({ |freq|
	101.collect{|i| sin((i/1000) * 2pi * freq)}
}).plot;
plotter.setGridProperties(\x,
	\labelAnchor, \topLeft,
	\labelAlign, \left,
	\labelOffset, 1 @ 5,
	\labelAppendString, " samp"
).setGridProperties(\y,
	\labelAnchor, \right,
	\labelAlign, \right,
	\labelOffset, -5 @ 0,
	\constrainLabelExtents, false
)
)
