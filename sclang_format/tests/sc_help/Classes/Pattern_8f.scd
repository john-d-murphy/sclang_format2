// Source: Classes/Pattern.schelp block 8 (part 6/27)
Prout({ |inval|
	inval = p.embedInStream(inval);
	inval = Event.silent(4).yield;
	inval = q.embedInStream(inval);
	inval = r.embedInStream(inval);
	inval;
}).play
