// Source: Classes/EZPopUpMenu.schelp block 0 (part 1/2)
(
w = Window.new.front;
w.view.decorator = FlowLayout(w.view.bounds);
g = EZPopUpMenu.new(
	w,
	230@22,
	"A PopUpMenu: ",
	[
		\item0 ->{|a| ("this is item 0 of " ++ a).postln},
		\item1 ->{|a| ("this is item 1 of " ++ a).postln},
		\item2 ->{|a| ("this is item 2 of " ++ a).postln},
	],
	globalAction: {|a| ("this is a global action of "++a.asString ).postln},
	initVal: 1,
	initAction: true,
	labelWidth: 120,
	labelHeight: 20,
	layout: \horz,
	gap: 2@2
);
)
