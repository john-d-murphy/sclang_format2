// Source: Classes/Interpreter.schelp block 1 (part 5/8)
g = fork { loop { 0.1.wait; a.set(\freq, 200 + 20.0.rand2.postln) } };
