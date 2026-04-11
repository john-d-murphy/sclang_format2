// Source: Reference/Literals.schelp block 28
{
	var f = { |n|
		if(n > 1) { n * f.value(n-1) } { 1 }
	};

	f.value(10);
}.value;
