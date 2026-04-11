// Source: Guides/Debugging-tips.schelp block 9
~synth={ arg t_trig; [LFNoise1.kr, LFNoise1.kr].poll(t_trig); }.play;

// the t_ in t_trig is shorthand to cause ~synth.set(\t_trig, 1) to trigger instead of set permanently
~synth.set(\t_trig, 1);
