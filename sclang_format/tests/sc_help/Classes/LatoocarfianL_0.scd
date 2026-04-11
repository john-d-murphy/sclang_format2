// Source: Classes/LatoocarfianL.schelp block 0
(
var a = 1, b = 3, c = 0.5, d = 0.5, xi = 0.5, yi = 0.5, size = 64;
plot(size.collect { var x = xi;
xi = sin(b * yi) + (c * sin(b * xi));
yi = sin(a * x) + (d * sin(a * yi));
xi
});
)
