// Source: Classes/Maybe.schelp block 7 (part 44/106)
~faculty = { |x| if(x == 1) { 1 } { x * ~faculty.(x - 1) } };
