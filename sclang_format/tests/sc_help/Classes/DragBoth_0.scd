// Source: Classes/DragBoth.schelp block 0
(
w = Window.new.front;
w.addFlowLayout;
// store various kinds of objects in the drag source

// a string source
a = DragBoth(w, Rect(10, 10, 150, 20)).align_(\center).background_(Color.rand);
a.object = "drag us around";

a = DragBoth(w, Rect(10, 10, 150, 20)).align_(\center).background_(Color.rand);
a.object="SUPERCOLLIDER";

8.do{
a = DragBoth(w, Rect(10, 10, 150, 20)).align_(\center).background_(Color.rand);
a.receiveDragHandler = { arg obj; obj.object = View.currentDrag.scramble };
}
)
