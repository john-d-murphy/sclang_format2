// Source: Classes/IdentitySet.schelp block 4 (part 1/5)
(
f = { |n = 4|
	var x, y, i;
	x = (0..n);
	y = x.as(IdentitySet);
	i = x.choose;
	bench { 100.do { x[i] } };
	bench { 100.do { y.scanFor(i) } };
}
);
