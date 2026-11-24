// Source: Tutorials/GUI/compose_complex_view.schelp block 0
(
var value = 1;
var displayValue = { |value|
	value.postln;
};

var sliderView = UserView()
.bounds_(Rect(0, 0, 400, 64));
var slider;
var text = StaticText()
.align_(\center)
.string_("Slider Name");
var field;

slider = Slider()
.orientation_(\horizontal)
.action_({
	value = slider.value;
	field.string_(
		value.trunc(0.01).asString);
	displayValue.value(value);
});

field = TextField()
.align_(\center)
.string_(value.asString)
.maxWidth_(64)
.action_({
	value = field.string.asFloat;
	slider.value_(value);
	displayValue.value(value);
});

sliderView.layout_(
	HLayout()
	.add(
		VLayout()
		.add(text)
		.add(slider),
	)
	.add(field)
);

sliderView.front;
)
