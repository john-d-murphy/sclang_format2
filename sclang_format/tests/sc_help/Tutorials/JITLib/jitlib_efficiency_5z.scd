// Source: Tutorials/JITLib/jitlib_efficiency.schelp block 5 (part 26/26)
(
~mix.task = Routine({
	loop({
		~mix.fadeTime = rrand(0.01, 0.1);
		~mix.read([~s1, ~s2, ~s3].choose);
		[0.2, 0.4].choose.wait;
	});
});
)
