// Source: Classes/Pen.schelp block 20
(
	w = Window("Pen Rotation and Scaling", Rect(128, 64, 360, 360));
	w.drawFunc = {
		Pen.use {
			// use the same rect for everything, just scale and rotate
			var r = Rect(0,0,200,80);
			Pen.fillColor = Color.black;
			// offset all subsequent co-ordinates
			Pen.translate(80,20);
			Pen.fillRect(r);
			Pen.fillColor = Color.red;
			// scale all subsequent co-ordinates
			Pen.scale(0.8, 0.8);
			Pen.translate(8,10);
			// rotate all subsequent co-ordinates
			Pen.rotate(0.1pi);
			Pen.fillRect(r);
			Pen.strokeColor = Color.blue;
			// lather, rinse, repeat
			Pen.scale(0.8, 0.8);
			Pen.rotate(0.1pi);
			Pen.width = 3;
			Pen.strokeRect(r);
			Pen.fillColor = Color.yellow(1,0.5);
			Pen.scale(0.8, 0.8);
			Pen.rotate(0.1pi);
			Pen.translate(20,-20);
			Pen.fillOval(r);
		}
	};

	w.front;
)
