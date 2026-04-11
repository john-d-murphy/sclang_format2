// Source: Classes/SCEnvelopeEdit.schelp block 1 (part 2/4)
(
e = Env([0, 1, 0.7, 0.9, 0], [0.03, 0.03, 0.03, 0.03], 'sin');
f = Env([0, 1, 0.7, 0.9, 0], [0.03, 0.03, 0.03, 0.03], 'sin');
w = Window("Shards", Rect(100, 100, 500, 400));
v = SCEnvelopeEdit(w, w.view.bounds.resizeBy(-20, -200), e, 10).resize_(2);
StaticText(w, v.bounds).string_(" amplitude").resize_(2);
x = SCEnvelopeEdit(w, v.bounds.moveBy(0, 200), f, 10).resize_(2);
StaticText(w, x.bounds).string_(" frequency").resize_(2);
w.front;
)
