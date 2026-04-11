// Source: Guides/GUI-Introduction.schelp block 7 (part 1/2)
~makeWindow = { var w;
	w = Window.new("Evader",Rect(500.rand + 100, 500.rand + 100, 200,50)).front;
	Button.new(w,Rect(10,10,180,30)).states_([["Evade"]]).action_(~makeWindow);
};
