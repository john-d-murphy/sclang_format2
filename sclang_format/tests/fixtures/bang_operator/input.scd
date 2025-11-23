(
// bang operator spacing

// duplication (binary) – should get spaces
var a, b, c, d;
a = [1, 2, 3]!2;
b = 1!3;
c = [10, 20]!  4;
d = (1 + 2)!5;

// unary not – should stay tight
var flag, x, y;
flag = true;
x = !flag;
y = a && !b;
if(!flag){
    "nope".postln;
};
while(!flag){
    "loop".postln;
};

// strings/comments with ! should be untouched
"!not an operator!".postln;
// comment: a = [1, 2, 3]!2; x = !flag;
)
