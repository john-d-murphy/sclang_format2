// Source: Classes/EZListView.schelp block 2
(
g = EZListView.new(nil,205@180, "Choose One: ", layout:\horz);
10.do{|i| g.addItem("item"++i.asString, {("this is item" ++i.asString). postln})};
g.setColors(Color.grey,Color.white);
)
