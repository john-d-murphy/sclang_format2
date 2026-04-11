// Source: Classes/EnvelopeView.schelp block 2 (part 1/2)
(
a = Window("text-boxes", Rect(200 , 450, 450, 450));
a.view.decorator = FlowLayout(a.view.bounds);

b = EnvelopeView(a, Rect(0, 0, 440, 440))
	.thumbWidth_(60.0)
	.thumbHeight_(15.0)
	.drawLines_(true)
	.drawRects_(true)
	.selectionColor_(Color.red)
	.value_([[0.1, 0.4, 0.5, 0.3], [0.1, 0.2, 0.9, 0.7]]);
4.do({arg i;
	b.setString(i, ["this", "is", "so much", "fun"].at(i));
	b.setFillColor(i,[Color.yellow, Color.white, Color.green].choose);
});
a.front;
)
