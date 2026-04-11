// Source: Classes/LevelIndicator.schelp block 7
(
w = Window().front().layout_(HLayout(
	LevelIndicator().style_(\continuous).value_(0.1).drawsPeak_(true).peakLevel_(0.3),
	LevelIndicator().style_(\continuous).value_(0.1).drawsPeak_(true).peakLevel_(0.5),
	LevelIndicator().style_(\continuous).value_(0.1).drawsPeak_(true).peakLevel_(0.7),
	LevelIndicator().style_(\continuous).value_(0.1).drawsPeak_(true).peakLevel_(0.9),
))
)
