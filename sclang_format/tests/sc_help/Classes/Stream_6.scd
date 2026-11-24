// Source: Classes/Stream.schelp block 6
(
Routine({ loop {
	"///".postln; (delta: 0.5).yield;
	"_/_".postln; (delta: 0.1).wait;
} }).asEventStreamPlayer.play;
)
