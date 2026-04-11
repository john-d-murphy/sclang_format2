// Source: Classes/SCImage.schelp block 18 (part 2/5)
(
	j = SCImage.new(150,50);
	j.draw({ arg bounds;
		j.drawStringAtPoint("Hello, world!", 10@10, Font("Lucida Grande", 24), Color.black);
	});
)
