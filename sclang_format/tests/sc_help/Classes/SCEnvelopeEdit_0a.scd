// Source: Classes/SCEnvelopeEdit.schelp block 0 (part 1/8)
(
e = Env([1, 2], [10]);
w = Window("Env Editor", Rect(200, 200, 300, 200));
v = SCEnvelopeEdit(w, w.view.bounds.moveBy(20, 20).resizeBy(-40, -40), e, 20).resize_(5);
w.front;
)
