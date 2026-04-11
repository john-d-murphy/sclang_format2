// Source: Classes/RandSeed.schelp block 0 (part 2/11)
(
x = { arg seed=1956;
		RandSeed.kr(Impulse.kr(MouseX.kr(0.1, 100)), seed);
}.play;
)
