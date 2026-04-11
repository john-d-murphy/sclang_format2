// Source: Tutorials/A-Practical-Guide/PG_Cookbook08_Swing.schelp block 7 (part 2/2)
{
			// if next note will swing, this note needs to be lengthened
			if(nextShouldSwing) {
				ev[\sustain] = ev.use { ~sustain.value } + adjust;
			};
		};
