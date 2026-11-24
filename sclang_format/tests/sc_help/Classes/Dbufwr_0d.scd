// Source: Classes/Dbufwr.schelp block 0 (part 4/11)
(
{
var read, write, readpos, writepos, writetrig;

	writetrig = Dust.kr(1);
	readpos = Dseries(0, 1, inf);
	writepos = Dseq([Dseries(0, 3, 30), Dseries(0, 1, 30)], inf);

	read = Dbufrd(b, readpos);
	write = Dbufwr(Dseq([Dseries(1, 1, 16), Dwhite(1, 16, 8)], inf) * 60, b, writepos);

	Demand.kr(writetrig, 0, write); // write on trigger

	SinOsc.ar(
		Demand.kr(Impulse.kr(16), 0, read).lag(0.01) * [1, 1.01]
	) * 0.1

}.play;
)
