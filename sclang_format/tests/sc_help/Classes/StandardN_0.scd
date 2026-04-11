// Source: Classes/StandardN.schelp block 0
(
var k = 1, xi = 0.5, yi = 0, size = 64;
plot(size.collect { yi = yi + (k * sin(xi)) % 2pi; xi = (xi + yi) % 2pi; xi - pi * 0.3183098861837907 });
)
