// Source: Classes/EZListView.schelp block 0 (part 2/2)
(
w = Window.new.front;
w.view.decorator = FlowLayout(w.view.bounds);
g = EZListView.new(w,200@230, " List:");
g.addItem(\item0, { |a| ("this is item 0 of " ++ a).postln });
g.addItem(\item1, { |a| ("this is item 1 of " ++ a).postln });
g.addItem(\item2, { |a| ("this is item 2 of " ++ a).postln });
g.setColors(Color.grey, Color.white);
)
