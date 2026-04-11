// Source: Classes/LinCongC.schelp block 0
(
var a = 1.1, c = 0.13, m = 1, xi = 0, size = 64;
plot(size.collect { xi = (a * xi + c) % m });
)
