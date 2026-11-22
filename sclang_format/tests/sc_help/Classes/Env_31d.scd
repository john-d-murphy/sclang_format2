// Source: Classes/Env.schelp block 31 (part 4/4)
(
e = Env.new([0.001, 1, 0.3, 0.8, 0.5, 0.8, 0], [2, 1, 1, 2, 3, 1] * 0.001, 'lin', 3, 1);
e.plot; { EnvGen.ar(e, Trig.ar(Impulse.ar(0), 10*0.001)) }.plot(0.02);
)
