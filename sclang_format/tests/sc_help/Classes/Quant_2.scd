// Source: Classes/Quant.schelp block 2
Pfuncn({ thisThread.clock.beats.debug("scheduled for"); nil }, 1)
	.play(quant: (
		nextTimeOnGrid: { |self, clock|
			clock.beats.roundUp(1).debug("clock beats") + rrand(self.lo, self.hi).debug("rand")
		},
		lo: 0, hi: 4
	));
