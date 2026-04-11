// Source: Classes/EZRanger.schelp block 1 (part 1/7)
(	// basic use
	w=Window.new.front;
	g=EZRanger(w, 400@16," test  ", \freq,{|v| v.value.postln},[50,2000],unitWidth:30);
	g.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);
);
