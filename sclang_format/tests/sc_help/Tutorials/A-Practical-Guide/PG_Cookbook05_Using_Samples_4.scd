// Source: Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.schelp block 4
f = { |val, array|
	var a, b, div;
	var i = array.indexOfGreaterThan(val);
	if(i.isNil) { array.size - 1 } {
		if(i == 0) { i } {
			a = array[i-1]; b = array[i];
			div = b / a;
			if(div == 1) { i } {
					// log() / log() == log(val/a) at base (b/a)
					// which is the inverse of exponential interpolation
				log(val / a) / log(div) + i - 1
			}
		}
	};
};
