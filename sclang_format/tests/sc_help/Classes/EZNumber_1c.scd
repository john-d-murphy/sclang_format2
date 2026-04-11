// Source: Classes/EZNumber.schelp block 1 (part 3/4)
(

m=nil;
m=2@2;		//comment for no margin

/////////////////
/// Layout \horz

(		// all features
		g=EZNumber(nil, 170@20," freq  ", \freq,unitWidth:30, numberWidth:60,layout:\horz,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180,50);
);

(		// no unitView
		g=EZNumber(nil, 170@20," freq  ", \freq,unitWidth:0, numberWidth:60,layout:\horz,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -20);
);

(		// no label, with unit. use window name as label
		g=EZNumber(nil, 120@20,nil, \freq,unitWidth:30, numberWidth:60,layout:\horz,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -90);
		g.window.name="Freq";
);


(		// no units, no label; use window name as label;
		g=EZNumber(nil, 120@20, nil, \freq,unitWidth:0, numberWidth:60,layout:\horz,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -160);
		g.window.name="Freq";
);

/////////////////
/// Layout \line2

(		// all features
		g=EZNumber(nil, 120@42," freq  ", \freq,unitWidth:30, numberWidth:60,layout:\line2,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(100,50);
);

(		// no unitView, with label
		g=EZNumber(nil, 170@42," freq  ", \freq,unitWidth:0, numberWidth:60,layout:\line2,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(100, -50);
);
(		// no unitView, no label; use window name as label
		g=EZNumber(nil, 170@20,nil, \freq,unitWidth:0, numberWidth:60,layout:\line2,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(100,-150);
		g.window.name="Freq";
);


)
