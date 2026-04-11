// Source: Classes/TextView.schelp block 0
(
var text = "Tous ces nombres paraissent bien concrets";
t = TextView(bounds: Rect(300, 400));
t.string = text;
t.front;
fork {
	loop {
		2.0.rand.wait;
		defer {
			t.setFont(Font("Times", rrand(12, 48)), rand(text.size - 1), rrand(3, 17));
			t.setStringColor(Color.rand, rand(text.size - 1), rrand(3, 17));

		}
	}
};
)
