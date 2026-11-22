// Source: Classes/Plotter.schelp block 4 (part 2/2)
(
var freq = 100;
{ LFPar.ar(freq * [1, 1.5, 2.25]) }.plot
.plotMode_(\filled)
.plotColor_(
    [\red, \green, \blue].collect{ |col|
        Color.perform(col).alpha_(0.2)
    }
).superpose_(true);
)
