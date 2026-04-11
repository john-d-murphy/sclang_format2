// Source: Guides/Debugging-tips.schelp block 23 (part 3/4)
p = Pbind(\degree, Pwalk((0..14), Pdup(Pwhite(1, 4, inf), Prand(#[-2, -1, 1, 2], inf)), Pseq(#[-1, 1], inf), 0), \delta, 0.25, \sustain, 0.2, \instrument, \default).trace.play;
