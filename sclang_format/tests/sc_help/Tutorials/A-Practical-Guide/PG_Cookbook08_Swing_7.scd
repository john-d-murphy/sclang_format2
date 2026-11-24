// Source: Tutorials/A-Practical-Guide/PG_Cookbook08_Swing.schelp block 7
if(thisShouldSwing) {
			ev[\timingOffset] = (ev[\timingOffset] ? 0) + adjust;
			// if next note will not swing, this note needs to be shortened
			if(nextShouldSwing.not) {
				ev[\sustain] = ev.use { ~sustain.value } - adjust;
			};
		} {
			// if next note will swing, this note needs to be lengthened
			if(nextShouldSwing) {
				ev[\sustain] = ev.use { ~sustain.value } + adjust;
			};
		};
