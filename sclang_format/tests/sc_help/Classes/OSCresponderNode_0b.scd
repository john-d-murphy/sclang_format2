// Source: Classes/OSCresponderNode.schelp block 0 (part 2/6)
o = OSCresponderNode(n, '/chat', { |t, r, msg| ("time:" + t).postln; msg[1].postln }).add;
