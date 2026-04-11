// Source: Guides/Spawning.schelp block 6 (part 1/9)
(
t = Task.new({
	inf.do({ arg i;
		i.postln;
		0.5.wait
	});
});
)
