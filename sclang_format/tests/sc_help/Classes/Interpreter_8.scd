// Source: Classes/Interpreter.schelp block 8
this.preProcessor = { |code| code.replace("SinOsc", "Saw") };

{ SinOsc.ar(200) * 0.1 }.play;

preProcessor = nil;
