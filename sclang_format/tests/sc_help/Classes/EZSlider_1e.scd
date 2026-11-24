// Source: Classes/EZSlider.schelp block 1 (part 5/7)
(

m = nil;
// m = 2@2;		// uncomment this for margin

/////////////////
/// Layout \horz

(		// all features, small font
		g = EZSlider(nil, 400@14, " freq  ", \freq, unitWidth: 30, numberWidth: 60, layout: \horz, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, 50);
		g.font_(Font("Helvetica", 10));
);

(		// no unitView
		g = EZSlider(nil, 400@16, " freq  ", \freq, unitWidth: 0, numberWidth: 60, layout: \horz, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -20);
);
(		// no label, so use window name as label
		g = EZSlider(nil, 400@16, nil, \freq, unitWidth: 0, numberWidth: 60, layout: \horz, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -90);
		g.window.name = "Freq";
);

/////////////////
/// Layout \line2

(		// all features
		g = EZSlider(nil, 300@42, " freq  ", \freq, unitWidth: 30, numberWidth: 60, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -160);
);

(		// no unitView, with label
		g = EZSlider(nil, 300@42, " freq  ", \freq, unitWidth: 0, numberWidth: 60, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -260);
);

(		// no label
		g = EZSlider(nil, 300@42, nil, \freq, unitWidth: 30, numberWidth: 60, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -360);
		g.window.name = "Freq";
);

(		// no lablel, so use window name as label
		g = EZSlider(nil, 150@42, nil, \freq, unitWidth: 0, numberWidth: 60, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -460);
		g.window.name = "Freq";
);

/////////////////
/// Layout \vert

(		// all features, small font
		g = EZSlider(nil, 45@300, " Vol  ", \db.asSpec.step_(0.01), unitWidth: 30, numberWidth: 60, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(250, 50);
		g.font_(Font("Helvetica", 10));
);
(		// no label, small font
		g = EZSlider(nil, 45@300, nil, \db.asSpec.step_(0.01), unitWidth: 30, numberWidth: 60, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(310, 50);
		g.font_(Font("Helvetica", 10));
);
(		// no Units small font
		g = EZSlider(nil, 45@300, " Vol", \db.asSpec.step_(0.01), unitWidth: 0, numberWidth: 60, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(370, 50);
		g.font_(Font("Helvetica", 10));
);
(		// no unitView, no Units small font
		g = EZSlider(nil, 45@300, nil, \db.asSpec.step_(0.01), unitWidth: 0, numberWidth: 60, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey(0.7), Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(430, 50);
		g.font_(Font("Helvetica", 10));
);

)
