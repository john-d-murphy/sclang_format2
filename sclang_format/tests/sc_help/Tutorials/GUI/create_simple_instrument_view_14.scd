// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 14
(
var window = Window();
var windowLayout = VLayout();

var pianoLayout = HLayout();
var frequencies = [60, 62, 64, 65, 67, 69, 71, 72].midicps;

var volume = 0.1;
var volumeSlider = Slider()
.orientation_(\horizontal)
.maxHeight_(60)
.value_(volume)
.action_({ volume = volumeSlider.value; });

var dur = 1;
var durMin = 0.1;
var durMax = 2;
var durSlider = Slider()
.orientation_(\horizontal)
.maxHeight_(60)
.action_({
	dur = durSlider.value;
	// linlin maps a value
	// from one linear range
	// to another linear range
	dur = dur.linlin(
		0, 1,
		durMin, durMax
	);
});

frequencies.do({ |frequency|
	var button = Button()
	.maxHeight_(200);
	button.action_({
		Synth(\instrView, [
			\freq, frequency,
			\amp, volume,
			\dur, dur,
		]);

	});
	pianoLayout.add(button);
});

windowLayout.add(volumeSlider);
windowLayout.add(durSlider);
windowLayout.add(pianoLayout);
window.layout_(windowLayout);
window.front;
)
