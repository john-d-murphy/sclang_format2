// Source: Classes/SimpleNumber.schelp block 16
(
l = [0, 1, 5, 9, 11]; // pentatonic scale
(1, 2..15).collect{|i|
	i.degreeToKey(l, 12)
};
)
