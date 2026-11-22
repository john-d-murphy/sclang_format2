// Source: Classes/Collection.schelp block 59 (part 1/2)
(
var data, steps = 15;
var minmax, range, binwidth;

data = { 15.0.rand + 3 }.dup(100);
minmax = [data.minItem, data.maxItem];
range = minmax[1] - minmax[0];
binwidth = range / steps;

data.histo(steps).plot(minval: 0)
.plotMode_(\steps)
.axisLabelY_("Occurrences")
.axisLabelX_("Bins")
.domainSpecs_(minmax.asSpec)
.domain_(binwidth * (0..steps-1) + data.minItem)
;
)
