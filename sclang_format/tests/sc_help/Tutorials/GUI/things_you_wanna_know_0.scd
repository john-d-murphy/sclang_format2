// Source: Tutorials/GUI/things_you_wanna_know.schelp block 0
(
var win = Window();
var slider= Slider();
var value = 0;

var routine = Routine({
	loop {
		value = 101.rand / 100;
		// Interacting with a widget from within a routine:
		// instructions must be nested in a function, and deferred
		{ slider.value_(value); }.defer;
		0.5.wait;
	};
}).play;

win.layout_(
	VLayout()
	.add(slider)
);

CmdPeriod.doOnce({
	routine.stop;
	win.close;
});

win.front;
)
