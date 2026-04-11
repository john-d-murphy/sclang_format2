// Source: Classes/Plotter.schelp block 8
( // inspect the \labelAnchor of each DrawGridX
var plotter  = [10, 34, 167].collect({ |freq|
	101.collect{|i| sin((i/1000) * 2pi * freq)}
}).plot;

plotter.plots.collect({ |plot|
	plot.drawGrid.x.labelAnchor
}).postln;
)
