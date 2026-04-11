// Source: Classes/Plotter.schelp block 22 (part 2/5)
(
x = { |i| (0..60).scramble * (3.5 ** i) }.dup(3);
x.plot("ARRAY:PLOT", Rect(200, 300, 600, 500));
)
