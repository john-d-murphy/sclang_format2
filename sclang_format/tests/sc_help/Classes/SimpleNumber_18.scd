// Source: Classes/SimpleNumber.schelp block 18
(
l = [0, 1, 5, 9, 11]; // pentatonic scale
(60, 61..75).postln.collect { |i| i.keyToDegree(l, 12).degreeToKey(l) }
)
