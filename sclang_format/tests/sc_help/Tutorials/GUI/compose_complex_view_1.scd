// Source: Tutorials/GUI/compose_complex_view.schelp block 1
(
// Specifying default value, and its range
var valueDefault = 440;
var valueMin = 440;
var valueMax = 880;
// Referencing value
// for keyboard events
var currentValue = valueDefault;

var window = Window("", Rect(100, 100, 400, 400));

var slider = Slider()
.orientation_(\horizontal)
.maxHeight_(64)
.value_(
	valueDefault.linlin(valueMin, valueMax, 0, 1)
);

var textField = TextField()
.string_(valueDefault.asString)
.align_(\center);

// The centralizing function:
var updateValue = { |value|
	// Clip the value to the correct range
	currentValue = value.clip(valueMin, valueMax);

	// This is where you'd implement actual controls
	// e.g.
	// synth.set(\freq, value);

	// Now we can update our interface

	// Adapt the value back to the slider's range
	slider.value_(
		currentValue.linlin(valueMin, valueMax, 0, 1
	));

	// Convert the value to string format for the textField
	textField.string_(currentValue.trunc(0.01).asString);
};

// The slider needs to map its value to the correct
// range before calling the function
slider.action_({
	updateValue.value(
		slider.value.linlin(0, 1, valueMin, valueMax)
	);
});

// The textField needs to convert its value
// to float format before calling the function
textField.action_({
	updateValue.value(textField.string.asFloat);
});

// Clicking the background removes
// slider and textField focus,
// allowing to use arrow keys
// to control the value directly
window.view.mouseDownAction_({
	slider.focus(false);
	textField.focus(false);
});

// Setup the windows view
// so it responds to arrow
// keys events
window.view.keyDownAction_({ |view, char, mod, unicode, keycode|
	switch(keycode)
	// Arrow LEFT detection
	{ 65361 } { updateValue.value(currentValue * 0.99); }
	// Arrow RIGHT detection
	{ 65363 } { updateValue.value(currentValue * 1.01); }
	// Arrow UP detection
	{ 65362 } { updateValue.value(currentValue * 1.1); }
	// Arrow DOWN detection
	{ 65364 } { updateValue.value(currentValue * 0.9); };
});

window.layout_(
	VLayout()
	.add(slider)
	.add(textField)
);

// Unfocus the slider,
// which has focus by default
window.view.focus(true);

window.front;
)
