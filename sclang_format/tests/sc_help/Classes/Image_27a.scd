// Source: Classes/Image.schelp block 27 (part 1/2)
(
i = Image.new(20@20);
i.pixels_(
	Int32Array.fill(i.width * i.height, {
		Image.colorToPixel(Color.new255(255.rand,127.rand,255.rand,255))
	})
);
//i.interpolation_(\fast); // uncomment to see the difference
w = i.plot(freeOnClose:true);
i.pixels.postln;
)
