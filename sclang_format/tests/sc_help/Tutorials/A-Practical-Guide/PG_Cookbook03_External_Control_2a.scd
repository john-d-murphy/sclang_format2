// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 2 (part 1/2)
(
var	pattern = Pbind(
		\degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
			+ Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
		\dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
	),
	player, window;

window = Window.new("Pattern trigger", Rect(5, 100, 150, 100))
		// onClose is fairly important
		// without it, closing the window could leave the pattern playing
	.onClose_({ player.stop });
Button.new(window, Rect(5, 5, 140, 90))
	.states_([["Pattern GO"], ["Pattern STOP"]])
	.font_(Font.new("Helvetica", 18))
	.action_({ |button|
		if(button.value == 1 and: { player.isNil or: { player.isPlaying.not } }) {
			player = pattern.play;
		} {
			player.stop;
			button.value = 0;
		};
	});
window.front;
)
