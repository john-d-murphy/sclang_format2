// Source: Classes/UserView.schelp block 9
(
var userView, win, blob = Rect(0, 0, 50, 50), trackblob=false, pmouse;

a = SCImage.new("/Library/Desktop Pictures/Ripples Blue.jpg");

win = SCWindow.new("refreshInRect Test", Rect(400, 400, 600, 200), scroll:true).front;
win.onClose_({ a.free; });

userView = SCUserView(win, Rect(10,10,2000,800))
	.backgroundImage_(a, 5)
	.drawFunc_({|me|
		Color.blue.setFill;
		Pen.fillRect(blob);
	})
	.mouseDownAction_({|v, x, y, mod|
		pmouse = x@y;
		trackblob = blob.containsPoint(pmouse);
	})
	.mouseUpAction_({|v, x, y, mod|
		trackblob = false;
	})
	.mouseMoveAction_({|v, x, y, mod|
		var refresh, mouse, delta;
		mouse = x@y;

		if(trackblob, {
			refresh = blob.copy;
			delta = mouse-pmouse;
			blob = blob.moveBy(delta.x, delta.y);
			refresh = refresh.union(blob);
			v.refreshInRect(refresh);
		});
		pmouse = mouse;
	});

blob = blob.moveBy(userView.bounds.left, userView.bounds.top);
userView.bounds.postln;
)
