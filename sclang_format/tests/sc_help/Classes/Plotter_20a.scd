// Source: Classes/Plotter.schelp block 20 (part 1/11)
( // units displayed in the axis labels by default
p = (4 ** (-1.5, -1.25 .. 0)).plot;
p.specs = \delay.asSpec.minval_(0.1);
p.domainSpecs = [0, 10, \lin, 0, 0, "xUnits"].asSpec;
p.setGridProperties(\y, \constrainLabelExtents, false);
p.setGridProperties(\x, \constrainLabelExtents, true);
)
