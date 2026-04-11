// Source: Classes/EZListView.schelp block 0 (part 1/2)
(
// default with vertical layout
w = Window.new.front;
w.view.decorator = FlowLayout(w.view.bounds);
g = EZListView.new(w,
	230@230,
	"An ListView:",
	[
		\item0 ->{ |a| ("this is item 0 of " ++ a).postln },
		\item1 ->{ |a| ("this is item 1 of " ++ a).postln },
		\item2 ->{ |a| ("this is item 2 of " ++ a).postln },
	],
	globalAction: { |a| ("this is a global action of "++a.asString ).postln },
	initVal: 2,
	initAction: true,
	labelWidth: 120,
	labelHeight: 16,
	layout: \vert,
	gap: 2@2
	);

)
