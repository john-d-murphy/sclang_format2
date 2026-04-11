// Source: Classes/Complex.schelp block 20
f = { |z| z * z + Complex(0.70176, 0.3842) };

(
var n = 80, xs = 400, ys = 400, dx = xs / n, dy = ys / n, zoom = 3, offset = -0.5;
var field = { |x| { |y| Complex(x / n + offset * zoom, y / n + offset * zoom) } ! n } ! n;

w = Window("Julia set", bounds:Rect(200, 200, xs, ys)).front;
w.view.background_(Color.black);
w.drawFunc = {
	n.do { |x|
		n.do { |y|
			var z = field[x][y];
			z = f.(z);
			field[x][y] = z;
			Pen.color = Color.gray(z.rho.linlin(-100, 100, 1, 0));
 			Pen.addRect(
				Rect(x * dx, y * dy, dx, dy)
			);
			Pen.fill
		}
	}
};

fork({ 6.do { w.refresh; 2.wait } }, AppClock)
)
