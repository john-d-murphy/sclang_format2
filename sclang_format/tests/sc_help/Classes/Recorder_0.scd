// Source: Classes/Recorder.schelp block 0
(
{ SinOsc.ar(
	SinOsc.ar(
		XLine.kr(1, 100, 5)).exprange(*XLine.kr([20, 800], [7000, 200], 10)
    )
   ) * 0.1

}.play;
s.record(duration: 10);
)
