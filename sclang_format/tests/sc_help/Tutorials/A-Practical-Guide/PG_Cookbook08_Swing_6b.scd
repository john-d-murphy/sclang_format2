// Source: Tutorials/A-Practical-Guide/PG_Cookbook08_Swing.schelp block 6 (part 2/3)
nextShouldSwing = ((nextTime absdif: now.round(ev[\swingBase])) <= (ev[\swingThreshold] ? 0)) and: {
			(nextTime / ev[\swingBase]).round.asInteger.odd
		};
