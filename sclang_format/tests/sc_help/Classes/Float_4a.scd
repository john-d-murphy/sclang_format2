// Source: Classes/Float.schelp block 4 (part 1/3)
f = { |x| if(x < 2) { x } { x * f.(x - 1) } };
