// Source: Guides/Debugging-tips.schelp block 12
r = fork { loop { b.get({ |value| l.add(value) }); 0.1.wait } };
