// Source: Classes/FuncStream.schelp block 2 (part 1/5)
(
var func, reset, count = 0;
func = { count = count + 2.rand };
reset = { count = 0 };
a = FuncStream(func, reset);
)
