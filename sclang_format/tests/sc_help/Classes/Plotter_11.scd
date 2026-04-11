// Source: Classes/Plotter.schelp block 11
(
var data, domain, plot;
domain = 25.collect({rrand(0, 50)}).sort;
data = domain.linlin(0, 50, 0, 1);

plot = data.plot.plotMode_(\points);
plot.domainSpecs_([0, 50].asSpec);
plot.domain_(domain);
)
