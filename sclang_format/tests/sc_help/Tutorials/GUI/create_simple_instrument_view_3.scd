// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 3
(
var window = Window();
var layout = HLayout();
var button = Button();
button.string_("Play");

button.action_({
	// This is the body of the function that the button will trigger
	Synth(\instrView);
	"ting".postln;
});

window.layout_(layout);
layout.add(button);
window.front;
)
