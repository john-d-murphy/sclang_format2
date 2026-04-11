// Source: Classes/SCImage.schelp block 20
(
	var operation='sourceOver', fraction=1.0, i, w;

	i = SCImage.new(
	//	"http://supercollider.sourceforge.net/theme/sc01/icon.supercollider.gif"
	//	SCDoc.helpSourceDir +/+ "images/duck_alpha.png"
		SCDoc.helpSourceDir +/+ "images/Swamp.png"
	);

	w = SCWindow.new("SCImage", Rect(120, 400, 360, 180)).front;

	SCSlider.new(w, Rect(10, 150, 150, 16))
		.value_(1.0)
		.action_({ arg sl;
			fraction = sl.value;
			w.refresh;
		});

	SCPopUpMenu.new(w, Rect(170, 150, 100, 16))
		.items_( SCImage.compositingOperations.collect({ arg i; i.asString }) )
		.value_(2)
		.action_({ arg pm;
			operation = SCImage.compositingOperations.at(pm.value);
			w.refresh;
		});

	w.onClose_({ i.free }); // free the image when the window is closed

	w.drawFunc_({

		i.drawAtPoint(10@10, nil, operation, fraction);

	});
)
