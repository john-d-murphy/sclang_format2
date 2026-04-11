// Source: Classes/OscN.schelp block 0 (part 10/11)
(
Routine({
	var n = 32;
	50.do({
		b.sine1(Array.rand(n,0,1).cubed, true, true, true);
		0.25.wait;
	});
}).play;
)
