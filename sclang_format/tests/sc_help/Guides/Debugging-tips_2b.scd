// Source: Guides/Debugging-tips.schelp block 2 (part 2/6)
o = OSCFunc({ |msg|
		// msg[3] is the first array value
		// [3..] means take everything in the array after that
	l.add(msg[3..]);
}, '/freqAmp', s.addr);
