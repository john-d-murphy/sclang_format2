// Source: Classes/QuadL.schelp block 0
(
var a = 1, b = -1, c = -0.75, xi = 0, size = 64;
plot(size.collect { xi = (a * (xi ** 2)) + (b * xi) + c; xi });
)
