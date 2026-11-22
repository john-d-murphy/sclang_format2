// Source: Classes/Float.schelp block 7 (part 6/7)
f = { |x| if(x < 2) { x } { x * f.(x - 1) } };
