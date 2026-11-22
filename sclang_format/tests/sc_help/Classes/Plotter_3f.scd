// Source: Classes/Plotter.schelp block 3 (part 6/6)
(
d = 4.collect({ |i| 100.collect({ |j| sinPi(1+i.squared*j * 50.reciprocal) }) });
p = d.plot;
p.plotColor_([Color.red, Color.cyan, Color.green, Color.blue]);
p.plotMode_([\steps, \linear, \plines, \points]);
p.superpose_(true);
)
