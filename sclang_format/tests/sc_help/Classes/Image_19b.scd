// Source: Classes/Image.schelp block 19 (part 2/5)
(
	j = Image.new(150,50);
	j.draw({ arg bounds;
		j.drawStringAtPoint("Hello, world!", 10@10, Font("Lucida Grande", 24), Color.black);
	});
)
