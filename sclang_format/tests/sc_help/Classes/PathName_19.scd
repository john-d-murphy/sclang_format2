// Source: Classes/PathName.schelp block 19
(
var table1, table2, table3;

table1 = Wavetable.sineFill(1024, [1,2,3]);
table2 = Signal.newClear.asWavetable;
table3 = Wavetable.sineFill(1024, Array.rand(64, 0.0, 1.0));

FileDialog.new(
	{ arg ok, path;
	var myPathName, myPathOnly;
	if (ok,
		{
			myPathName = PathName.new(path);
			myPathOnly = myPathName.pathOnly;
			("writing files tables1-3 to"+myPathOnly).postln;
			table1.write(myPathOnly ++ "table1");
			table2.write(myPathOnly ++ "table2");
			table3.write(myPathOnly ++ "table3");
		}
	)
	}
)
)
