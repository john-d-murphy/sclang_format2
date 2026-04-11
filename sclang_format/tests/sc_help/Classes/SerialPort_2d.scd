// Source: Classes/SerialPort.schelp block 2 (part 4/6)
fork { p.putAll(Int8Array[13, 10]) };

p.doneAction = { "my serial port got closed".postln; }
