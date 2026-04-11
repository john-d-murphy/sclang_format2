// Source: Classes/FlowView.schelp block 4
(
f = FlowView.new;

GUI.slider.new(f, Rect(0,0,100,100));

// flow within a flow
g = f.flow({ arg g;
	ActionButton(g,"a");
	GUI.slider.new(g,Rect(0,0,100,100)).background_(Color.rand);
}).background_(Color.black); // shrinks to fit the contents afterwards
)
