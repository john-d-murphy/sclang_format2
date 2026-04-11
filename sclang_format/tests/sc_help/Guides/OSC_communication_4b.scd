// Source: Guides/OSC_communication.schelp block 4 (part 2/3)
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);
