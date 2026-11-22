// Source: Classes/ListView.schelp block 1
(
s.waitForBoot({
	var f, freq, ww;
	n = { r = LFSaw.ar([220, 530], 0, 0.1)*LFPulse.ar(12, 0, 0.3, 0.4); [r[0], Delay2.ar(r[1])] }.play;
	freq = { SinOsc.kr(0.5, 0, 4000, 4200) }.play;
	w = Window("Filters").front;
	v = ListView(w, Rect(10, 10, 180, 120))
	.items_(["No Filter", "RLPF", "RHPF", "BPF", "Resonz", "MoogFF"])
	.background_(Color.clear)
	.hiliteColor_(Color.green(alpha: 0.6))
	.action_({ |v|
		v.value.switch(
			0, { try{ f.free }; "test".postln },
			1, { try{ f.free }; f = { ReplaceOut.ar(0, RLPF.ar(In.ar(0, 2), In.kr(0, 1), 0.2, 0.3)) }.play(addAction: \addToTail) },
			2, { try{ f.free }; f = { ReplaceOut.ar(0, RHPF.ar(In.ar(0, 2), In.kr(0, 1), 0.2, 0.3)) }.play(addAction: \addToTail) },
			3, { try{ f.free }; f = { ReplaceOut.ar(0, BPF.ar(In.ar(0, 2), In.kr(0, 1), 0.2, 1.5)) }.play(addAction: \addToTail) },
			4, { try{ f.free }; f = { ReplaceOut.ar(0, Resonz.ar(In.ar(0, 2), In.kr(0, 1), 0.2, 2)) }.play(addAction: \addToTail) },
			5, { try{ f.free }; f = { ReplaceOut.ar(0, MoogFF.ar(In.ar(0, 2), In.kr(0, 1), 1.5)) }.play(addAction: \addToTail) }
		);
	});
	
	ww = FreqScope.new(400, 200, 0);
	w.bounds = Rect(50, Window.screenBounds.height-300, 200, 200);
	ww.window.bounds = ww.window.bounds.moveTo(255, Window.screenBounds.height-328);
	CmdPeriod.doOnce({ { ww.window.close }.defer(0.5); w.close });
	// defer or crash, because FreqScopeWindow Class contains its own routine for cleaning up on CmdPeriod
	w.onClose_({ n.free; f.free; freq.free });
});
)
