// Source: Guides/GUI-Introduction.schelp block 10
(
	w = Window.new.front;
	a = Button(w, Rect(10, 10, 200, 20)).states_([["Hi There!"]]);
	a.beginDragAction = { a.dragLabel ="I'm dragging: \""++ a.states[0][0]++"\""; a.states[0][0] };
	DragSink(w,Rect(10,40,200,20)).align_(\center).string="Cmd-drag from Button to here";
)
