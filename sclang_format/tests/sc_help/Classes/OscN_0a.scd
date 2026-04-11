// Source: Classes/OscN.schelp block 0 (part 1/11)
(
s = Server.local;
b = Buffer.alloc(s,512,1);
b.sine1(1.0/[1,2,3,4,5,6],true,false,true);

SynthDef("help-OscN",{ arg out=0,bufnum=0;
	Out.ar(out,
		OscN.ar(bufnum, 500, 0, 0.5)
	)
}).play(s,[0,0,1,b.bufnum]);

)
