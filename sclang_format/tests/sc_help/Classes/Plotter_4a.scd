// Source: Classes/Plotter.schelp block 4 (part 1/2)
(
d = 4.collect({ |i|
    100.collect({ |j|
        sinPi(1+i.squared*j * 50.reciprocal)
    })
});
d.plot.plotColor_([Color.red, Color.cyan, Color.green, Color.blue]);
)
