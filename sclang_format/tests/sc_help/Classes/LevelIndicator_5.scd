// Source: Classes/LevelIndicator.schelp block 5
(
w = Window(bounds: 100@400).front().background_(Color.black);
w.layout_(HLayout(
	LevelIndicator()
		.numMajorTicks_(16)
		.numTicks_(16)
		.value_(0.75)
))
)
