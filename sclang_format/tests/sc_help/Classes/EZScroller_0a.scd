// Source: Classes/EZScroller.schelp block 0 (part 1/7)
(
w = Window.new("EZScroller test", Rect(100, 400,200, 100)).front;
// 5 displays
v = { |i| DragBoth.new(w, Rect(0, i * 20, 100, 20)) }.dup(5);
// 12 items
a = (1..12);

e = EZScroller(w, Rect(100,0,14,100), v.size, a.size, { |sc|
	var startIndex = sc.value.asInteger.postcs;
	v.do { |drag, i| drag.object_( a[ (startIndex) + i] ? ""); };
	e.visible_(sc.numItems > sc.maxItems); // hide when not useful
});
e.doAction;
)
