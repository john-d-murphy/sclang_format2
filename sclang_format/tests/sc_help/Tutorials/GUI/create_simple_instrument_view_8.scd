// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 8
(
var window = Window();
var layout = HLayout();
// Getting the C Major Scale, as frequencies, using MIDI notation:
var frequencies = [60, 62, 64, 65, 67, 69, 71, 72].midicps;

// For every frequency...
frequencies.do({ |frequency|

	// ...this particular button...
	var button = Button()
	.maxHeight_(200);

	// ...will use this particular frequency.
	button.action_({
		Synth(\instrView, [\freq, frequency]);
	});

	layout.add(button);
});

window.layout_(layout);
window.front;
)
