// Source: Classes/EZText.schelp block 1 (part 3/6)
(

m=nil;
m=2@2;		//comment for no margin

/////////////////
/// Layout \horz

(		// with label
		g=EZText(nil, 170@20," freq  ", textWidth:120,layout:\horz,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180,50);
);

(		// no label. use window name as label
		g=EZText(nil, 120@20, layout:\horz,margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(-180, -90);
		g.window.name="Freq";
);

/////////////////
/// Layout \vert

(		// all features
		g=EZText(nil, 120@60," freq  ", textWidth: 120,layout: \vert, margin:m);
		g.setColors(Color.grey,Color.white,background: Color.grey(0.7));
		g.window.bounds = g.window.bounds.moveBy(100,50);
);

)
