// Source: Classes/LocalIn.schelp block 0 (part 3/4)
(
{
	var local, in, amp;

	in = SoundIn.ar([0, 1]);

	amp = Amplitude.kr(Mix.ar(in));
	in = in * (amp > 0.02); // noise gate

	local = LocalIn.ar(2);
	local = OnePole.ar(local, 0.4);
	local = OnePole.ar(local, -0.08);

	local = Rotate2.ar(local[0], local[1], 0.2);

	local = DelayN.ar(local, 0.25, 0.25);

	local = LeakDC.ar(local);
	local = ((local + in) * 1.25).softclip;

	LocalOut.ar(local);
	local * 0.1;
}.play;
)
