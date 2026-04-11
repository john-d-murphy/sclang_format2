// Source: Overviews/Operators.schelp block 15 (part 2/2)
{ FSinOsc.ar(500,0.0, XLine.kr(0.1, 10, 10)).softclip * 0.25 }.scope(2);
