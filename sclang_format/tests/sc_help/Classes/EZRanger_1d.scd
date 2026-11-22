// Source: Classes/EZRanger.schelp block 1 (part 4/9)
(

m = nil;
m = 2@2; // comment for no margin


/////////////////
/// Layout \horz

(		// all features, small font
		g = EZRanger(nil, 400@16, " freq  ", \freq,
			initVal: [100.rand, 200+2000.rand], unitWidth: 30, numberWidth: 60, layout: \horz, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, 50);
		g.font_(Font("Helvetica", 10));
);

(		// no unitView
		g = EZRanger(nil, 400@16, " freq  ", \freq, initVal: [100.rand, 200+2000.rand],
			unitWidth: 0, numberWidth: 60, layout: \horz, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, -20);
		g.font_(Font("Helvetica", 10));
);
(		// no label, so use window name as label
		g = EZRanger(nil, 400@16, nil, \freq, initVal: [100.rand, 200+2000.rand],
			unitWidth: 0, numberWidth: 60, layout: \horz, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, -90);
		g.window.name = "Freq";
		g.font_(Font("Helvetica", 10));
);

/////////////////
/// Layout \line2

(		// all features
		g = EZRanger(nil, 300@42, " freq  ", \freq, initVal: [100.rand, 200+2000.rand],
			unitWidth: 30, numberWidth: 60, layout: \line2, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, -160);
);

(		// no unitView, with label
		g = EZRanger(nil, 300@42, " freq  ", \freq, initVal: [100.rand, 200+2000.rand],
			unitWidth: 0, numberWidth: 60, layout: \line2, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, -260);
);

(		// no label
		g = EZRanger(nil, 300@42, nil, \freq, initVal: [100.rand, 200+2000.rand],
			unitWidth: 30, numberWidth: 60, layout: \line2, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, -360);
		g.window.name = "Freq";
);

(		// no label, so use window name as label
		g = EZRanger(nil, 150@42, nil, \freq, initVal: [100.rand, 200+2000.rand],
			unitWidth: 0, numberWidth: 60, layout: \line2, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white));
		g.window.bounds = g.window.bounds.moveBy(-180, -460);
		g.window.name = "Freq";
);

/////////////////
/// Layout \vert

(		// all features, small font
		g = EZRanger(nil, 45@300, " Vol  ", \db.asSpec.step_(0.01), initVal: [-3-15.rand, -2.rand],
			unitWidth: 30, numberWidth: 60, layout: \vert, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white, \h));
		g.window.bounds = g.window.bounds.moveBy(250, 50);
		g.font_(Font("Helvetica", 9));
);
(		// no label, small font
		g = EZRanger(nil, 45@300, nil, \db.asSpec.step_(0.01), initVal: [-3-15.rand, -2.rand],
			unitWidth: 30, numberWidth: 60, layout: \vert, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white, \h));
		g.window.bounds = g.window.bounds.moveBy(310, 50);
		g.font_(Font("Helvetica", 9));
);
(		// no Units small font
		g = EZRanger(nil, 45@300, " Vol", \db.asSpec.step_(0.01), initVal: [-3-15.rand, -2.rand],
			unitWidth: 0, numberWidth: 60, layout: \vert, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white, \h));
		g.window.bounds = g.window.bounds.moveBy(370, 50);
		g.font_(Font("Helvetica", 9));
);
(		// no unitView, no units small font
		g = EZRanger(nil, 45@300, nil, \db.asSpec.step_(0.01), initVal: [-3-15.rand, -2.rand],
			unitWidth: 0, numberWidth: 60, layout: \vert, margin: 2@2);
		g.setColors(Color.grey, Color.white, Color.grey(0.7),
			Color.grey, Color.white, Color.yellow, background: Color.grey(0.7),
				knobColor: HiliteGradient(Color.grey, Color.white, \h));
		g.window.bounds = g.window.bounds.moveBy(430, 50);
		g.font_(Font("Helvetica", 9));
);

)
