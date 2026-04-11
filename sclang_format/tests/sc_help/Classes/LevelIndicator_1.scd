// Source: Classes/LevelIndicator.schelp block 1
(
w = Window().front.layout_(
	HLayout(
		LevelIndicator().style_(\continuous).value_(1/3),
		LevelIndicator().style_(\led).value_(2/3),
)
)
)
