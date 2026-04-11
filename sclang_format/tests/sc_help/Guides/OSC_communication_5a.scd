// Source: Guides/OSC_communication.schelp block 5 (part 1/2)
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye');
