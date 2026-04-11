// Source: Classes/AmpCompA.schelp block 0
(
var k =  3.5041384e16;
var c1 = 424.31867740601;
var c2 = 11589.093052022;
var c3 = 544440.67046057;
var c4 = 148698928.24309;
f = {|f|
var r = squared(f);
var m1 = pow(r,4);
var n1 = squared(c1 + r);
var n2 = c2 + r;
var n3 = c3 + r;
var n4 = squared(c4 + r);
var level = k * m1 / (n1 * n2 * n3 * n4);
sqrt(level)
};
)
