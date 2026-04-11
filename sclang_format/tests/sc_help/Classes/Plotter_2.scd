// Source: Classes/Plotter.schelp block 2
(
a = Plotter("the plot", Rect(600, 30, 800, 250));
a.value = (0..1000).normalize(0, 14pi).curdle(0.01).scramble.flat.sin;
)
