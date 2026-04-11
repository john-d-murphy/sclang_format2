// Source: Classes/Pen.schelp block 25
(
var w, h = 800, v = 600, seed = Date.seed, phase = 0, zoom = 0.7, zoomf = 1, run = true;
w = Window("affines", Rect(40, 40, h, v));
w.view.background = Color.blue(0.4);
w.onClose = { run = false };
w.front;
w.drawFunc = {
	thisThread.randSeed = Date.seed;
	if (0.0125.coin) { seed = Date.seed; phase = 0; zoom = 0.7; zoomf = exprand(1/1.01, 1.01); }
	{ phase = phase + (2pi/80); zoom = zoom * zoomf; };
	thisThread.randSeed = seed;
	Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.grey(1,0.5);
		Pen.width = 8.linrand + 1;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 8.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 0.05.wait; } }.fork(AppClock)

)
