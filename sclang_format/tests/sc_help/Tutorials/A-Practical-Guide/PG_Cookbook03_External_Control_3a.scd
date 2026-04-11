// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 3 (part 1/2)
(
var	pattern = Pbind(
		\degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
			+ Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
		\dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
	),
	player;

~noteOnFunc = MIDIFunc.noteOn({
	if(player.isNil or: { player.isPlaying.not }) {
		player = pattern.play;
	} {
		player.stop;
	};
// 60 limits this MIDIFunc to listen to middle-C only
// but it will pick up that note from any port, any channel
}, 60);
)
