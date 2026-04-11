// Source: Classes/SimpleNumber.schelp block 8
(
l = [0, 1, 5, 9, 11]; // pentatonic scale
(60, 61..76).collect { |i| i.nearestInScale(l, 12) }
)
