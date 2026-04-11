// Source: Classes/Function.schelp block 0
(
var a, b, c;
a = { [100, 200, 300].choose };	// a Function
b = { 10.rand + 1 };	// another Function
c = a + b; 	// c is a Function.
c.value.postln;	// evaluate c and print the result
)
