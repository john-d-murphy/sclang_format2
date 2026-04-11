// Source: Classes/HenonC.schelp block 0
(
var a = 1.4, b = 0.3, x0 = 0, x1 = 1, size = 64;
plot(size.collect { var aux = 1 - (a * (x1 ** 2)) + (b * x0); x0 = x1; x1 = aux; aux });
)
