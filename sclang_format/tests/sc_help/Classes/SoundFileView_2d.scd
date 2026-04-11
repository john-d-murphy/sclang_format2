// Source: Classes/SoundFileView.schelp block 2 (part 4/4)
(
var w = Window("test", Rect(700, 200, 600, 300)),
sfv, sfZoom, mouseButton,
dur = d.size / f.sampleRate / f.numChannels;

w.layout = VLayout(
	sfv = SoundFileView(),
	sfZoom = RangeSlider().orientation_(\horizontal)
);

sfZoom.lo_(0).range_(1)
.action_({ |view|
	var divisor, rangeStart;
	rangeStart = view.lo;
	divisor = 1 - sfZoom.range;
	if(divisor < 0.0001) {
		rangeStart = 0;
		divisor = 1;
	};
	sfv.xZoom_(sfZoom.range * dur)
	.scrollTo(rangeStart / divisor)
});

sfv.setData(d, startFrame: 0, channels: f.numChannels, samplerate: f.sampleRate);

sfv.mouseDownAction_({ |view, x, y, mod, buttonNumber|
	mouseButton = buttonNumber;
})
.mouseUpAction_({ |view, x, y, mod|
	mouseButton = nil;
})
.mouseMoveAction_({ |view, x, y, mod|
	var rangeSize, rangeStart;
	if(mouseButton == 1) {
		rangeSize = view.xZoom / dur;
		rangeStart = view.scrollPos * (1 - rangeSize);
		sfZoom.lo_(rangeStart).range_(rangeSize);
	};
});

w.front;
)
