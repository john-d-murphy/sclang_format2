// Source: Classes/Plotter.schelp block 3 (part 14/14)
(
d = 4.collect({ |i| 100.collect({ |j| sinPi(1+i.squared*j * 50.reciprocal) })});
p = d.plot;
p.plotColor_([Color.red, Color.cyan, Color.green, Color.blue]);
p.plotMode_([\steps, \linear, \plines, \points]);
// superpose will trigger a refresh to update colors/modes
p.superpose_(true);
)
