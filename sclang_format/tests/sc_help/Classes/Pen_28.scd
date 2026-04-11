// Source: Classes/Pen.schelp block 28
(
	var blendMode=0, blendString="Normal";
	w = Window.new.front;
	m = PopUpMenu(w, Rect(10, w.view.bounds.height - 30, 150, 20));
	m.items = [
		"0 - Normal",
		"1 - Multiply",
		"2 - Screen",
		"3 - Overlay",
		"4 - Darken",
		"5 - Lighten",
		"6 - ColorDodge",
		"7 - ColorBurn",
		"8 - SoftLight",
		"9 - HardLight",
		"10 - Difference",
		"11 - Exclusion",
		"12 - Hue",
		"13 - Saturation",
		"14 - Color",
		"15 - Luminosity"
	];

	m.action_({|view|
		blendMode = view.value;
		blendString = view.items.at(blendMode);
		w.refresh;
	});
	w.drawFunc = {
		80.do{|i|
			Pen.use {
			Pen.blendMode_(blendMode);
			Pen.color = Color.green(0.6, 0.10);
			Pen.addRect(
				Rect(20, 20, 20 + (i*4), 20 + (i*4));
			);
			Pen.fill;
			};
		}
	};
	w.refresh;
)
