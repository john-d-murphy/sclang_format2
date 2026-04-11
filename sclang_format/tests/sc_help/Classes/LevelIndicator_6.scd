// Source: Classes/LevelIndicator.schelp block 6
(
w = Window().front().layout_(HLayout(
	LevelIndicator().style_(\continuous).value_(0.75).drawsPeak_(true).peakLevel_(0.9),
	LevelIndicator().style_(\led).value_(0.75).drawsPeak_(true).peakLevel_(0.9)
))
)
