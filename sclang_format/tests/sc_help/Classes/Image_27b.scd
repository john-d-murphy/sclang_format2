// Source: Classes/Image.schelp block 27 (part 2/2)
(
i = Image.color(50@50, Color.white);
i.setPixels(
	Int32Array.fill(20*20,{Image.colorToPixel(Color.new255(255.rand,127.rand,255.rand,255))}),
	Rect(10,10,20,20)
);
i.interpolation_(\fast); // uncomment to see the difference
w = i.plot(freeOnClose:true);
i.pixels.postln;
)
