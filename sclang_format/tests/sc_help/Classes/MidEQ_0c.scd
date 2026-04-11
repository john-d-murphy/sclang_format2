// Source: Classes/MidEQ.schelp block 0 (part 3/10)
(
x = {| freq=400, db=0, rq=0.1 |
	 var in;
	 in =  SinOsc.ar([ 400, 420 ], 0, 0.4);
	 MidEQ.ar(in, freq, Lag.kr(rq, 0.3), db)
	}.play
)
