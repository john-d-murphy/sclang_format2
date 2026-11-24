// Source: Tutorials/JITLib/jitlib_efficiency.schelp block 5 (part 15/26)
(
t = Task({
	var dt;
	loop({
		dt = rrand(0.01, 0.3);
		~mix.fadeTime = dt;
		~mix.read([~s1, ~s2, ~s3].choose);
		dt.wait;
	});
});
)
