// Source: Classes/Environment.schelp block 4 (part 2/2)
(
var orc;
orc = Environment.make {
	~a = { |freq, amp, pan|
		Pan2.ar(SinOsc.ar(freq), pan, amp);
	};
	~b = { |amp, pan, freq|
		Pan2.ar(RLPF.ar(Saw.ar(freq), freq * 6, 0.1), pan, amp);
	};
	~c = { |pan, freq, amp|
		Pan2.ar(Resonz.ar(GrayNoise.ar, freq * 2, 0.1), pan, amp * 2);
	};
	~orc = [~a, ~b, ~c];
};
// 'reverb'
{ var in; in = In.ar(0, 2); CombN.ar(in, 0.2, 0.2, 3, 1, in) }.play(addAction: \addToTail);

{ loop({
	orc.use({
			// set values in the environment
		~freq = exprand(80, 600);
		~amp = 0.1;
		~pan = 1.0.rand2;

			// call a randomly chosen instrument function
			// with values from the environment

		 x = { ~orc.choose.valueEnvir }.play(fadeTime: 0.2, addAction: \addToHead);
		 0.2.wait;
		 x.release(0.2);
	});
}) }.fork;

)
