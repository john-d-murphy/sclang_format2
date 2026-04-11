// Source: Classes/Dbufwr.schelp block 0 (part 7/8)
(
{
var read, write, readpos, writepos, writetrig;

	writetrig = Impulse.kr(2);
	readpos = Dbufrd(b, 1); // first buffer val is position
	writepos = Dbufrd(b, 0); // second buffer val is position
	read = Dbufrd(b, readpos);

	write = Dbufwr(read, b, writepos);

	Demand.kr(writetrig, 0, write); // write on trigger
}.play;
)
