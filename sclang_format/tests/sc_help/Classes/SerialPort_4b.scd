// Source: Classes/SerialPort.schelp block 4 (part 2/4)
(
r = Routine({
	var byte, str, res;
	99999.do{ |i|
		if(p.read == 10, {
			str = "";
			while({ byte = p.read; byte != 13 }, {
				str = str++byte.asAscii;
			});
			res = str.asInteger;
			("read value:"+res).postln;
		});
	};
}).play;
)
