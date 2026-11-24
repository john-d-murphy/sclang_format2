// Source: Classes/LevelIndicator.schelp block 4
(
w = Window(bounds: 100@400).front().background_(Color.black);
w.layout_(HLayout(
	LevelIndicator()
		.numTicks_(16)
		.value_(0.75)
))
)
