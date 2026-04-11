// Source: Classes/FlowView.schelp block 5
(
f = FlowView.new;

GUI.slider.new(f, Rect(0,0,100,100));

// SuperCollider composite view
g = f.comp({ arg g;
	GUI.slider.new(g, Rect(50,30,50,100)).background_(Color.rand);
	GUI.slider.new(g, Rect(120,30,50,100)).background_(Color.rand);
},Rect(0, 0, 200, 200)).background_(Color.black);

f.startRow;
"Back to flowing".gui(f);
)
