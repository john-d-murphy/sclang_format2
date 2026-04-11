// Source: Classes/RunningSum.schelp block 1
(
{
    var input, numsamp;

    input = LFSaw.ar;
    numsamp = 30;

    (RunningSum.ar(input.squared, numsamp) / numsamp).sqrt
}.play
)
