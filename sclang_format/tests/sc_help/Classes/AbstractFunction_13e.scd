// Source: Classes/AbstractFunction.schelp block 13 (part 5/5)
{ a = Pitch.kr(SoundIn.ar).at(1); Pulse.ar(a.cpsmidi.round.midicps) * 0.1 }.play;
