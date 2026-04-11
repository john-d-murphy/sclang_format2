// Source: Classes/ControlSpec.schelp block 7
(
var spec;
spec = [ 100, 18000, \exp].asSpec;
{
	var freq,osc;
	osc = SinOsc.kr(0.1).range(0,1);
	freq = spec.map( osc );

	freq.dump;// BinaryOpUGen

	SinOsc.ar(
		freq.poll
	)
}.play
)
