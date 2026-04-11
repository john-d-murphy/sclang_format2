// Source: Classes/OscN.schelp block 0 (part 3/11)
(
// noninterpolating - there are noticeable artifacts
// modulate freq

s = Server.local;
b = Buffer.alloc(s,512,1);
b.sine1(1.0/[1,2,3,4,5,6].squared,true,false,true);

SynthDef("help-OscN",{ arg out=0,bufnum=0;
	Out.ar(out,
		OscN.ar(bufnum, XLine.kr(2000,200), 0, 0.5)
	)
}).play(s,[\out,0,\bufnum,b.bufnum]);

)
