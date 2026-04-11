// Source: Classes/SerialPort.schelp block 2 (part 3/6)
fork { p.read.postln }; // may suspend thisThread - should be called within a routine

// write a byte to the device

fork {p.put(42) }; // may suspend thisThread - should be called within a routine

// write multiple bytes to the device

fork { p.putAll("whaddayawant") };
