// Source: Classes/Maybe.schelp block 7 (part 46/106)
~faculty = { |x| if(x == 1) { 1 } { x * ~faculty.apply(x - 1) } };
