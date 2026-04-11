// Source: Tutorials/Mark_Polishook_tutorial/11_Test_functions.schelp block 1
(
	{
		SinOsc.ar([440.067, 441.013], 0, 1)
		*
		SinOsc.ar([111, 109], 0, 0.2)
	}.scope;
)
