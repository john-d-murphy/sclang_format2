// Source: Classes/Plotter.schelp block 19 (part 1/7)
(
p = 4.collect({
	100.collect({ rrand(0,1.0) })
}).plot(bounds: Rect(50,50,500,650));
p.plotColor_([Color.red, Color.blue, Color.green, Color.cyan]);
)
