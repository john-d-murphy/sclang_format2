// Source: Classes/Plotter.schelp block 17 (part 1/15)
(
a = (4 ** (-5..0)).postln.plot;
a.specs = \delay; a.refresh;
a.domainSpecs = [0, 10, \lin, 0, 0, " Kg"].asSpec; a.refresh;
);
