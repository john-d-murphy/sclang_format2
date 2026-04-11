// Source: Classes/Float.schelp block 5 (part 1/9)
(
g = { |a, b|
	if(b == 0) {
		a
	} {
		g.(b, mod(a, b))
	}
}
)
