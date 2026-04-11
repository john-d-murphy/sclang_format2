// Source: Classes/LevelIndicator.schelp block 2
(
w = Window().front.layout_(HLayout(
	LevelIndicator().style_(\led).value_(0.8).stepWidth_(1),
	LevelIndicator().style_(\led).value_(0.8).stepWidth_(3),
	LevelIndicator().style_(\led).value_(0.8).stepWidth_(10),
	LevelIndicator().style_(\led).value_(0.8).stepWidth_(50),
));
)
