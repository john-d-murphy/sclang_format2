// Source: Classes/Pbindf.schelp block 0 (part 1/11)
(
a = Pbind(\x, Pseq([1, 2, 3]), \zzz, 9000); // input stream
b = Pbindf(a, \y, Prand([100, 300, 200], inf), \zzz, 99);
x = b.asStream;
)
