// Source: Classes/Stethoscope.schelp block 5 (part 1/5)
(
{ 
	var f = { |l,h| SinOsc.kr(0.1, {pi.rand}).range(l, h) } ;
	Pulse.ar({ f.(20, 1000) }!6, { f.(0.0, 1) }!6, { f.(0.0, 1.0) }!6) 
}.play;
)
