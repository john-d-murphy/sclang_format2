// Source: Classes/StaticText.schelp block 1
(
var w, a, r, b, q;
w = Window("Frequency Monitor", Rect(200, Window.screenBounds.height - 200, 300, 150)).front;

a = StaticText(w, Rect(45, 10, 200, 20)).background_(Color.rand);
a.string = " Current Frequency ";

Button.new(w, Rect(45, 70, 200, 20)).states_([["close", Color.black, Color.rand]]).action_({ w.close });

s.waitForBoot({

    b = Bus.new(\control, 0, 1);

    q = SynthDef(\Docs_FreqMonitor, {
		var freq, snd;
        freq = LFNoise0.ar(2, 400, 650);
        snd = SinOsc.ar(freq, 0, 0.2);
        Out.ar(0, snd);
        Out.kr(b.index, freq); // output the frequency to a control bus
    }).play;

    r = Routine {
		{
			// Set the value of the StaticText to the value in the control bus.
			// Setting GUI values is asynchronous, so you must use .defer in the system clock.
			// Also you must check if the window is still open, since Routine will continue for at least
			// one step after you close the window.
			b.get({ |v|
				{
					if(w.isClosed.not) {
						a.string = " Current Frequency: " ++ v.round(0.01)
					}
				}.defer
			});

			0.01.wait;
		}.loop

    }.play
});

CmdPeriod.doOnce({ w.close });
w.onClose = { r.stop; q.free; b.free }; // clean up if the window closes
)
