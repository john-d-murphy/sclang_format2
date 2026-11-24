// Source: Tutorials/A-Practical-Guide/PG_06f_Server_Control.schelp block 1 (part 1/3)
(
SynthDef(\volumeCtl, { |out, amp = 1, gate = 1|
	var	sig = In.ar(out, 2) * amp;
	sig = sig * EnvGen.kr(Env(#[1, 1, 0], #[1, 1], -3, releaseNode: 1), gate, doneAction: Done.freeSelf);
	ReplaceOut.ar(out, sig)
}).add;

~vbus1 = Bus.control(s, 1).set(0.5);
~vbus2 = Bus.control(s, 1).set(0.5);

~window = Window.new("mixers", Rect(10, 100, 320, 60));
~window.view.decorator = FlowLayout(~window.view.bounds, 2@2);
EZSlider(~window, 310@20, "low part", \amp, { |ez| ~vbus1.set(ez.value) }, 0.5);
~window.view.decorator.nextLine;
EZSlider(~window, 310@20, "high part", \amp, { |ez| ~vbus2.set(ez.value) }, 0.5);
~window.front.onClose_({ ~vbus1.free; ~vbus2.free });
)
