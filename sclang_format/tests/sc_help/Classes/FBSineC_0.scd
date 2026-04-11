// Source: Classes/FBSineC.schelp block 0
(
var im = 1, fb = 0.1, a = 1.1, c = 0.5, xi = 0.1, yi = 0.1, size = 64;
plot(size.collect { xi = sin((im * yi) + (fb * xi)); yi = (a * yi + c) % 2pi; xi });
)
