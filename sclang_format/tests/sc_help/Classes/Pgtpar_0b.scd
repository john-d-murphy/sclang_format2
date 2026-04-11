// Source: Classes/Pgtpar.schelp block 0 (part 2/4)
(
x = Pbind(
    \instrument, \help_sinegrain,
    \degree, Pseq(#[0, 5, 4, 2, 1, 1, 3], inf),
    \dur, Pseq(#[0.25, 0.5, 1.0], inf),
    \scale, #[0, 3, 5, 9, 10]
);
a = Pbus(Pgtpar([0.0, x, 1.5, x, 2.25, x])).play;
)
