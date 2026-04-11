// Source: Classes/RunningSum.schelp block 3
(
{
    var input, numsamp, power;
    numsamp = 500;
    input = SoundIn.ar;
    power = MouseX.kr(0.1, 4);

    (RunningSum.ar(input ** power, numsamp)/numsamp) ** (power.reciprocal)
}.play
)
