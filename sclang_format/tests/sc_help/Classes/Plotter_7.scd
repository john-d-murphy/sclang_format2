// Source: Classes/Plotter.schelp block 7
(
var plotter, labelAnchors;
plotter = [10, 34, 167].collect({ |freq|
	101.collect{|i| sin((i/1000) * 2pi * freq)}
}).plot;

labelAnchors = [\topLeft, \top, \bottomLeft];

plotter.plots.do{ |plot, i|
	plot.drawGrid.x
	.labelAnchor_(labelAnchors[i])
	.constrainLabelExtents_(true);
};
plotter.updatePlotBounds;
)
