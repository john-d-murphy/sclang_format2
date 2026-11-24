// Source: Classes/Server.schelp block 21
(
s.waitForBoot {
	// Open a plotTree window with a refresh rate of 2 seconds:
	s.plotTree(2);

	// Define and play a repeating pattern that generates a new synth every 0.5 seconds:
	x = Pn((dur: 0.5, midinote: 69, amp: 0.1)).play;

	/*
	Since the plotTree window refreshes every 2 seconds,
	displaying only the most recent node,
	the first node will appear after a 2-second delay (once four notes have played),
	meaning only every fourth synth node is visible.
	*/

	5.wait; // wait for 5 seconds.

	x.stop; // stop the playback of the pattern

	2.wait; // wait for 2 seconds.

	s.nodeTreeView.close; // close the plotTree window
}
)
