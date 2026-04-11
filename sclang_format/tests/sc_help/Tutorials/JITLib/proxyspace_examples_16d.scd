// Source: Tutorials/JITLib/proxyspace_examples.schelp block 16 (part 4/5)
(
~out = InstrSpawner({ arg freq=1900,env,pan;
	Pan2.ar(SinOsc.ar(freq, 0.5pi, 0.3) * EnvGen.kr(env, doneAction: Done.freeSelf), pan)
},[
	Prand([1500, 700, 800, 3000] + 170.rand2, inf),
	Env.perc(0.002,0.01),
	Prand([-1,1],inf)
],0.125)
)
