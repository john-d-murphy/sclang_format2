// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 6
(
var	pattern = Pbind(
		\degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
			+ Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
		\dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
	),
	player;

// Quicky GUI to tune threshold and decay times
~w = Window("threshold setting", Rect(15, 100, 300, 100))
	.onClose_({
		~ampSynth.free;
		~ampUpdater.free;
		~oscTrigResp.free;
		player.stop;
	});
~w.view.decorator = FlowLayout(~w.view.bounds, 2@2, 2@2);
~ampView = EZSlider(~w, 295@20, "amplitude", \amp, labelWidth: 80, numberWidth: 60);
~ampView.sliderView.canFocus_(false).enabled_(false);
~ampView.numberView.canFocus_(false).enabled_(false);
StaticText(~w, 295@5).background_(Color.gray);
~threshView = EZSlider(~w, 295@30, "threshold", \amp, action: { |ez|
	~ampSynth.set(\thresh, ez.value);
}, initVal: 0.4, labelWidth: 80, numberWidth: 60);
~decayView = EZSlider(~w, 295@30, "decay", #[0.1, 100, \exp], action: { |ez|
	~ampSynth.set(\decay, ez.value);
}, initVal: 80.0, labelWidth: 80, numberWidth: 60);

~w.front;

~ampSynth = SynthDef(\ampSynth, { |inbus, thresh = 0.8, decay = 1|
	var	amp = Amplitude.kr(In.ar(inbus, 1), attackTime: 0.01, releaseTime: decay);
		// this trigger (id==0) is to update the gui only
	SendReply.kr(Impulse.kr(10), '/amp', amp);
		// this trigger gets sent only when amplitude crosses threshold
	SendReply.kr(amp >= thresh, '/amptrig');
}).play(args: [inbus: s.options.numOutputBusChannels, thresh: ~threshView.value, decay: ~decayView.value]);

~ampUpdater = OSCFunc({ |msg|
	defer { ~ampView.value = msg[3] }
}, '/amp', s.addr);

~oscTrigResp = OSCFunc({ |msg|
	if(player.isNil or: { player.isPlaying.not }) {
		player = pattern.play;
	} {
		player.stop;
	};
}, '/amptrig', s.addr);
)
