// Source: Tutorials/A-Practical-Guide/PG_Cookbook02_Manipulating_Patterns.schelp block 2 (part 1/2)
(
var	pitches = (0..14),	// replace with other pitches you want
	move = 0,
	window, slider;

window = Window.new("Mouse Transport", Rect(5, 100, 500, 50));
slider = Slider.new(window, Rect(5, 5, 490, 20))
	.action_({ |view|
		move = (view.value * 4 - 2).round;
	})
	.value_(0.5);
window.front;

p = Pbind(
		// Pfunc is the direction to move through the array
		// it could be anything
		//   - could read from MIDI or HID and convert it into a step
		//   - could be a GUI control, as it is here
	\degree, Pwalk(pitches, Pfunc { move }, 1, 7),
	\dur, 0.25
).play;
)
