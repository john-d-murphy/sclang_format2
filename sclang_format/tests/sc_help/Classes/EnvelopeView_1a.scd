// Source: Classes/EnvelopeView.schelp block 1 (part 1/2)
(
w = Window("envelope", Rect(150 , Window.screenBounds.height - 250, 400, 150)).front;
w.view.decorator = FlowLayout(w.view.bounds);

b = EnvelopeView(w, Rect(0, 0, 350, 100))
	.thumbSize_(5)
	.drawLines_(true)
	.fillColor_(Color.green)
	.selectionColor_(Color.red)
	.drawRects_(true)
	.value_([(0.0, 0.1 .. 1.0), (0.0, 0.1 .. 1.0)])
	.setEditable(0,false);
)
