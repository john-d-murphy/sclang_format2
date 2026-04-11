// Source: Classes/FunctionList.schelp block 7 (part 2/4)
d.keyDownAction = { "You touched the keyboard.".postln };

d.keyDownAction = d.keyDownAction.addFunc {:x, x<-(1..), :: "already % times\n\n".postf(x) };


d.keyDownAction = nil;
