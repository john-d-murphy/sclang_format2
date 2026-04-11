// Source: Classes/Pdefn.schelp block 5 (part 4/4)
(
Pdefn(\deg, {
	loop {
	5.do { |i|
		#[1, 3, 4].choose.yield;
		#[5, 0, 12].choose.yield;
		#[14, 3, 4].choose.do { |j| (i % j).postln.yield };
	}
	}
})
)
