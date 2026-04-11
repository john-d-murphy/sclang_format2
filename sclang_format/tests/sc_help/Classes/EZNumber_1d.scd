// Source: Classes/EZNumber.schelp block 1 (part 4/4)
(
// start server
s.waitForBoot({

	var w, startButton, noteControl, cutoffControl, resonControl;
	var balanceControl, ampControl;
	var node, cmdPeriodFunc;

	// define a synth
	SynthDef("window-test", { |out, note = 36, fc = 1000, rq = 0.25, bal=0, amp=0.4, gate = 1|
			var x;
			x = Mix.fill(4, {
				LFSaw.ar((note + {0.1.rand2}.dup).midicps, 0, 0.02)
			});
			x = RLPF.ar(x, fc, rq).softclip;
			x = RLPF.ar(x, fc, rq, amp).softclip;
			x = Balance2.ar(x[0], x[1], bal);
			x = x * EnvGen.kr(Env.cutoff, gate, doneAction: Done.freeSelf);
			Out.ar(out, x);
		}, [0.1, 0.1, 0.1, 0.1, 0.1, 0]
	).add;



	// make the window
	w = Window("another control panel", Rect(200, 400, 300, 180));
	w.front; // make window visible and front window.
	w.view.decorator = FlowLayout(w.view.bounds);

	w.view.background = Color.rand;

	// add a button to start and stop the sound.
	startButton = Button(w, 75 @ 20);
	startButton.states = [
		["Start", Color.black, Color.green],
		["Stop", Color.white, Color.red]
	];
	startButton.action = {|view|
			if (view.value == 1) {
				// start sound
				node = Synth( "window-test", [
					"note", noteControl.value,
					"fc", cutoffControl.value,
					"rq", resonControl.value,
					"bal", balanceControl.value,
					"amp", ampControl.value.dbamp ]);
			} {
				// set gate to zero to cause envelope to release
				node.release; node = nil;
			};
	};

	// create controls for all parameters
	w.view.decorator.nextLine;
	noteControl = EZNumber(w, 160 @ 20, "Note ", ControlSpec(24, 60, \lin, 1),
		{|ez| node.set( "note", ez.value )}, 36);

	w.view.decorator.nextLine;
	cutoffControl = EZNumber(w, 160 @ 20, "Cutoff ", ControlSpec(200, 5000, \exp),
		{|ez| node.set( "fc", ez.value )}, 1000);

	w.view.decorator.nextLine;
	resonControl = EZNumber(w, 160 @ 20, "Reson", ControlSpec(0.1, 0.7),
		{|ez| node.set( "rq", ez.value )}, 0.2);

	w.view.decorator.nextLine;
	balanceControl = EZNumber(w, 160 @ 20, "Balance ", \bipolar,
		{|ez| node.set( "bal", ez.value )}, 0);

	w.view.decorator.nextLine;
	ampControl = EZNumber(w, 160 @ 20, "Amp ", \db,
		{|ez| node.set( "amp", ez.value.dbamp )}, -6);


	// set start button to zero upon a cmd-period
	cmdPeriodFunc = { startButton.value = 0; };
	CmdPeriod.add(cmdPeriodFunc);

	// stop the sound when window closes and remove cmdPeriodFunc.
	w.onClose = {
		node.free; node = nil;
		CmdPeriod.remove(cmdPeriodFunc);
	};
});
)
