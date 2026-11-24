// Source: Classes/PatternProxy.schelp block 3 (part 8/8)
(
x.source = Prout {
	loop {
	4.do { |i|
		#[2, 3, 4].choose.yield;
		#[5, 0, 11].choose.yield;
		#[6, 3, 4].choose.do { |j| (i % j).yield };
	}
	}
}
)
