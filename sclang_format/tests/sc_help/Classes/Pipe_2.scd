// Source: Classes/Pipe.schelp block 2
(
var p, l;
p = Pipe.new("ping -c10 sourceforge.net", "r");	// list directory contents in long format
l = p.getLine;					// get the first line
while({l.notNil}, {l.postln; l = p.getLine; });	// post until l = nil
p.close;					// close the pipe to avoid that nasty buildup
)
