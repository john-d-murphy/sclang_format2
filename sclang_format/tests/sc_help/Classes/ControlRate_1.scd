// Source: Classes/ControlRate.schelp block 1
( 
{
	var freq = 400;
	
	// pulses at control rate:
	(LFPulse.ar(ControlRate.ir,0,0.01,2,-1) * [1,0,0,0]) 
	
	// Sinewave at control rate:
	+ (SinOsc.kr(freq) * [0,1,0,0])
	
	// pulses at sample rate:
	+ (LFPulse.ar(SampleRate.ir/2,0,0.1,2,-1) * [0,0,1,0]) 
	
	// Sinewave at sample rate:
	+ (SinOsc.ar(freq) * [0,0,0,1])
	
}.plot(0.01);
)
