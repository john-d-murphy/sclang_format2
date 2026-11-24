// Source: Classes/EZKnob.schelp block 1 (part 4/20)
(
m = nil;
m = 2@2;		// comment this for no margin

/////////////////
/// Layout \line2

(		// all features, small font
		g = EZKnob(nil, 128@40, " freq  ", \freq, unitWidth: 20, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, 50);
		g.font_(Font("Helvetica", 10));
);

(		// no unitView
		g = EZKnob(nil, 118@40, " freq  ", \freq, unitWidth: 0, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -40);
);
(		// no label, so use window name as label
		g = EZKnob(nil, 118@30, nil, \freq, labelWidth: 100, unitWidth: 20, layout: \line2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -130);
		g.window.name = "Freq";
);

/////////////////
/// Layout \horz


(		// all features
		g = EZKnob(nil, 200@28, " freq  ", \freq, unitWidth: 30, layout: \horz, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(0, 50);
);

(		// no unitView
		g = EZKnob(nil, 160@28, " freq  ", \freq, layout: \horz, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(0, -30);
);
(		// no label, so use window name as label
		g = EZKnob(nil, 120@28, nil, \freq, layout: \horz, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(0, -110);
		g.window.name = "Freq";
);



/////////////////
/// Layout \vert

(		// all features
		g = EZKnob(nil, 82@82, " freq  ", \freq, unitWidth: 18, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.font_(Font("Helvetica", 10));
		g.window.bounds = g.window.bounds.moveBy(220, 50);
);

(		// no unitView, with label
		g = EZKnob(nil, 70@90, " freq  ", \freq, unitWidth: 0, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(220, -90);
);

(		// no label
		g = EZKnob(nil, 120@60, nil, \freq, unitWidth: 30, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(220, -230);
		g.window.name = "Freq";
);

(		// no lablel, so use window name as label
		g = EZKnob(nil, 120@60, nil, \freq, unitWidth: 0, layout: \vert, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(220, -340);
		g.window.name = "Freq";
);


/////////////////
/// Layout \vert2

(		// all features
		g = EZKnob(nil, 82@82, " freq  ", \freq, unitWidth: 18, layout: \vert2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.font_(Font("Helvetica", 10));
		g.window.bounds = g.window.bounds.moveBy(350, 50);
);

(		// no unitView, with label
		g = EZKnob(nil, 70@90, " freq  ", \freq, unitWidth: 0, layout: \vert2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(350, -90);
);

(		// no label
		g = EZKnob(nil, 120@60, nil, \freq, unitWidth: 30, layout: \vert2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(350, -230);
		g.window.name = "Freq";
);

(		// no lablel, so use window name as label
		g = EZKnob(nil, 120@60, nil, \freq, unitWidth: 0, layout: \vert2, margin: m);
		g.setColors(Color.grey, Color.white, Color.grey,
			Color.white, Color.yellow, nil, nil, Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(350, -340);
		g.window.name = "Freq";
);


)
