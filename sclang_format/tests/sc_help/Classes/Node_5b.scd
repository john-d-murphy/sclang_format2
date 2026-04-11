// Source: Classes/Node.schelp block 5 (part 2/4)
(
x = SynthDef("help-node-setn", {
	arg out, freq1 = 440, freq2 = 440, freq3 = 440, amp1 = 0.05, amp2 = 0.05, amp3 = 0.05;
	Out.ar(out, Mix(SinOsc.ar([freq1, freq2, freq3], 0, [amp1, amp2, amp3])))
}).play;
)
