// Source: Classes/DelayN.schelp block 0 (part 1/2)
(
// Dust randomly triggers Decay to create an exponential
// decay envelope for the WhiteNoise input source
{
z = Decay.ar(Dust.ar(1,0.5), 0.3, WhiteNoise.ar);
DelayN.ar(z, 0.2, 0.2, 1, z); // input is mixed with delay via the add input
}.play
)
