// Source: Classes/EZSlider.schelp block 1 (part 7/7)
(
// start server
s.waitForBoot({

var w, startButton, sliders;
var node, cmdPeriodFunc;
var params, specs;

// define a synth
SynthDef("window-test", { |out, note = 36, fc = 1000, rq = 0.25, bal = 0, amp = 0.4, width = 0, gate = 1|
		var x;
		x = Mix.fill(4, {
			VarSaw.ar((note + { 0.1.rand2 }.dup).midicps, 0, width, 0.02)
		});
		x = RLPF.ar(x, fc, rq).softclip;
		x = RLPF.ar(x, fc, rq, amp).softclip;
		x = Balance2.ar(x[0], x[1], bal);
		x = x * EnvGen.kr(Env.cutoff, gate, 5, doneAction: Done.freeSelf);
		Out.ar(out, x);
	}, [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0]
).add;


params = ["note", "fc", "rq", "bal", "amp", "width"];
specs = [
	ControlSpec(24, 60, \lin, 1, 36, \note),
	ControlSpec(200, 5000, \exp, 0.01, 1000, \Hz),
	ControlSpec(0.1, 0.7, \lin, 0.001, 0.2, \rq),
	ControlSpec(-1, 1, \lin, 0, 0, \pan),
	ControlSpec(0.0001, 2, \exp, 0, 0.3, \vol), // db spec acts weird, so use self made one
	ControlSpec(0, 1, \lin, 0, 0.3, \width),
];

// make the window
w = Window("another control panel", Rect(20, 400, 440, 180));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap = 2@2;


// add a button to start and stop the sound.
startButton = Button(w, 75 @ 20);
startButton.states = [
	["Start", Color.black, Color.green(0.7)],
	["Stop", Color.white, Color.red(0.7)]
];
startButton.action = { |view|
		var args;
		if (view.value == 1) {
			// start sound
			params.do { |param, i|
				args = args.add(param);
				args = args.add(sliders[i].value)
			};
			node = Synth("window-test", args.postcs);
		} {
			// set gate to zero to cause envelope to release
			node.release; node = nil;
		};
};

// create controls for all parameters
w.view.decorator.nextLine;
sliders = params.collect { |param, i|
	EZSlider(w, 430 @ 20, param, specs[i], { |ez| node.set(param, ez.value) })
		.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey, Color.white, Color.yellow);
};
// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0 };
CmdPeriod.add(cmdPeriodFunc);

// stop the sound when window closes and remove cmdPeriodFunc.
w.onClose = {
	node.free; node = nil;
	CmdPeriod.remove(cmdPeriodFunc);
};

})
)
