// Source: Classes/EZListView.schelp block 3
(
g = EZListView.new(bounds: 200@230); // no label
12.do{ |i| g.addItem("item"++i.asString, { ("this is item" ++i.asString).postln }) };
g.view.parent.findWindow.name = " choose item";
)
