// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 16
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
// Creating the text, and assigning a string
var volumeText = StaticText()
.string_("Volume")
.align_(\center);

var dur = 1;
var durMin = 0.1;
var durMax = 2;
var durSlider = Slider()
.orientation_(\horizontal)
.maxHeight_(60)
.value_(dur.linlin(durMin, durMax, 0, 1))
.action_({
	dur = durSlider.value;
	dur = dur.linlin(0, 1, durMin, durMax);
});
// And here
var durText = StaticText()
.string_("Duration")
.align_(\center);

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

// Inserting the volume text before the volume slider:
windowLayout.add(volumeText, 1);
windowLayout.add(volumeSlider, 3);
// Inserting the duration text before the duration slider,
// after the volume slider:
windowLayout.add(durText, 1);
windowLayout.add(durSlider, 3);

windowLayout.add(pianoLayout, 8);
window.layout_(windowLayout);
window.front;
)
