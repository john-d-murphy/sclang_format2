// Source: Classes/GbmanN.schelp block 0
(
var xi = 1.2, yi = 2.1, size = 64;
plot(size.collect { var x; xi = 1 - yi + abs(x = xi); yi = x; xi });
)
