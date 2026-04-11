// Source: Guides/Debugging-tips.schelp block 11 (part 3/5)
r = fork { loop { l.add(b.getSynchronous); 0.1.wait } };

r.stop;
