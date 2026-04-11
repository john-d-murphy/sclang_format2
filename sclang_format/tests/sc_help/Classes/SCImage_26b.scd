// Source: Classes/SCImage.schelp block 26 (part 2/2)
(
	i = SCImage.color(50@50, Color.white);
	i.setPixels(
		Int32Array.fill(20*20,{Integer.fromRGBA(255.rand, 127.rand, 255.rand, 255)}),
		Rect(10,10,20,20)
	);
	i.interpolation_(\none); // uncomment to see the difference
	w = i.plot(freeOnClose:true);
	i.pixels.postln;
)
