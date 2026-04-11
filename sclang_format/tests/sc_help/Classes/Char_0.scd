// Source: Classes/Char.schelp block 0
for(0,255,{ arg i;
	var a;
	[i,a = i.asAscii,a.isAlphaNum,a.isPrint,a.isPunct,a.isControl].postln;
});
