// Source: Classes/MouseButton.schelp block 0 (part 3/5)
(
SynthDef( \mousexyb, { |out=0|
	var mousex, mousey, mousebutton;
	mousex = MouseX.kr( 500, 1000 ); // this will determine the frequency of the sound (minimum value, maximum value, warp, lag)
	mousey = MouseY.kr( 0, 0.3 ); // this will determine the amplitude of the sound
	mousebutton = MouseButton.kr( 0, 1, 2 ); // this will turn the sound on or off (minimum value, maximum value, lag)
	Out.ar( out, SinOsc.ar( mousex, 0, mousey ) * mousebutton );
}).add
)
