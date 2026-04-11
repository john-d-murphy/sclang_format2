// Source: Tutorials/JITLib/proxyspace_examples.schelp block 17 (part 4/18)
(
t = Task.new({
	loop({
		// starts a synth with the current synthdef at index 0
		~out.spawn([\pmf, [1, 20, 300].choose, \pan, [0, -1, 1].choose]);
		[0.1, 0.01, 0.25].choose.wait;
	})
});
)
