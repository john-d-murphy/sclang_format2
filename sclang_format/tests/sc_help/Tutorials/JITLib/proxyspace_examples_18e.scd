// Source: Tutorials/JITLib/proxyspace_examples.schelp block 18 (part 5/11)
(
t = Task({
	loop({
		s.sendMsg("/s_new","grain",-1,0,0,
			\i_out, ~someInput.index, // returns the bus index of the proxy
			\pan, [1, 1, -1].choose * 0.2
		);
		[0.01, 0.02].choose.wait;
	})
});
)
