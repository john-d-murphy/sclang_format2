// Source: Classes/ReadableNodeIDAllocator.schelp block 0 (part 5/8)
3.do { s.nextNodeID.postln };


// make a dummy server with different clientID
r = Server(\remote4, s.addr, s.options, clientID: 4);
