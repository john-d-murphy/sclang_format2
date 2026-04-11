// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 9 (part 1/6)
(
~z = {
	Splay.ar(
		SinOsc.ar(Rand(300,400) + ({exprand(1, 1.3)} ! rrand(1, 9)))
		* LFCub.ar({exprand(30, 900)} ! rrand(1, 9))
		* LFSaw.kr({exprand(1.0, 8.0)} ! rrand(1, 9)).max(0)
		* 0.1
	)
};
)
