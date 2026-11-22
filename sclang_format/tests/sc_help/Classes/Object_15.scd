// Source: Classes/Object.schelp block 15
(
// Cartesian to Polar and back, accumulating precision error
var x = 3.0, y = 5.0;
var hypot = hypot(y, x);
var angle = atan2(y, x);
var polar = Polar(hypot, angle);
var xFromPolar = polar.asPoint.x;
var equalWithin = 1e-5;
postf(
	"Exactly equal? %\n"
	"Fuzzily equal? %\n",
    x == xFromPolar,
    fuzzyEqual(x, xFromPolar, equalWithin) > 0
);
[x, xFromPolar]
)
