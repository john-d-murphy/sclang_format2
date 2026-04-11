// Source: Classes/SCImage.schelp block 19
(
	var width, height, tgHeight, ratio, str, font, color, strb, targetWidth=400, shadowColor, run = true;
	shadowColor = Color.black;

	color = Color.gray(0.8);
	str = "I Love Pixels";
	font = Font("Monaco", 10);
	strb = str.bounds(font);
	width = strb.width;
	height = strb.height;
	ratio = height / width;
	i = SCImage(width@(height));
	i.draw({|bb|
		SCPen.smoothing_(false);
		i.drawStringAtPoint(str, 0@0, font, color);
	});
	i.interpolation_(\none);
	tgHeight = targetWidth * ratio;
	w = SCWindow.new("", Rect(400,400, 450, 150)).drawFunc_({
		SCPen.setShadow(2@2, 0.4, color:Color.red);
		i.drawInRect(Rect(5,5,targetWidth, tgHeight));
	});

	w.view.background_(Color.white);
	w.onClose_({run = false; i.free;});
	w.front;
)
