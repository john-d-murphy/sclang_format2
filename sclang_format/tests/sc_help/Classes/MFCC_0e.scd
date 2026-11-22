// Source: Classes/MFCC.schelp block 0 (part 5/6)
(
var ms;

w = Window.new("Thirteen MFCC coefficients", Rect(200, 400, 300, 300));

ms = MultiSliderView.new(w, Rect(10, 10, 260, 280));

ms.value_(Array.fill(13, 0.0));
ms.valueThumbSize_(20.0);
ms.indexThumbSize_(20.0);
ms.gap_(0);

w.front;

r = {

	inf.do {

		c.getn(13, { |val| { ms.value_(val * 0.9) }.defer });
		0.04.wait; // 25 frames per second
	}

}.fork

)
