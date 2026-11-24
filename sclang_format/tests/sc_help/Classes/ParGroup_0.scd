// Source: Classes/ParGroup.schelp block 0
fork {
	p = ParGroup.new;
	loop {
		(
			degree: rrand(0.0, 12.0).round(1/4),
			group: p,
			db: rrand(-30, -25),
			pan: rrand(-1.0, 1.0)
		).play;
		0.2.wait;
	}
}
