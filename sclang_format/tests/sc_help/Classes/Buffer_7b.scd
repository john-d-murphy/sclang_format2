// Source: Classes/Buffer.schelp block 7 (part 2/4)
(
a = Array.fill(2000000,{ rrand(0.0,1.0) }); // a LARGE collection
b = Buffer.sendCollection(s, a, 1, 0, {arg buf; "finished".postln;});
)
