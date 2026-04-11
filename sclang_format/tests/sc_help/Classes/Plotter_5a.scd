// Source: Classes/Plotter.schelp block 5 (part 1/2)
(
a = { (0..30).scramble }.dup(2).plot;
a.setProperties(
  \fontColor, Color.yellow,
  \plotColor, Color.magenta,
  \backgroundColor, Color.black,
  \gridColorX, Color.green,
  \gridColorY, Color.green,
  \labelX, "Frames",
  \labelFontColor, Color.magenta
);
a.refresh;
);
