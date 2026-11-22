// Source: Classes/Float.schelp block 5 (part 1/6)
f = { |x| if(x < 2) { x } { x * f.(x - 1) } };
