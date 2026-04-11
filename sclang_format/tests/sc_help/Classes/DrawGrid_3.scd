// Source: Classes/DrawGrid.schelp block 3
(
x = [0, 10].asSpec.units_("sec");
y = [0, 1].asSpec.units_("amp");
d = DrawGrid((500@250).asRect, x.grid, y.grid);

// set its properties before testing
d.x.tickSpacing_(25);
d.linePattern_(FloatArray[10.0, 5.0, 2.0, 5.0]);

// generate a preview
~testView = d.preview;
)
