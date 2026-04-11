// Source: Classes/AbstractGridLines.schelp block 1
(
// LinearGridLines
var linGrid = ControlSpec(0, 100, \lin, units: "Time").grid;
// ExponentialGridLines
var expGrid = \freq.asSpec.grid;

DrawGrid.test(linGrid, expGrid);
)
