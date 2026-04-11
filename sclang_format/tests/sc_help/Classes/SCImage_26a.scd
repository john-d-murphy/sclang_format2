// Source: Classes/SCImage.schelp block 26 (part 1/2)
(
	i = SCImage.new(20@20);
	i.pixels_(
		Int32Array.fill(i.width * i.height, {
			Integer.fromRGBA(255.rand,127.rand,255.rand,255)
		})
	);
	//i.interpolation_(\none); // uncomment to see the difference
	w = i.plot(freeOnClose:true);
	i.pixels.postln;
)
