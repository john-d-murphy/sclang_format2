// Source: Classes/UserView.schelp block 5
(
var w, txt, lines, points, drawLine;

drawLine = { |points, bounds|
	var p0;
	points.do { |p,i|
		if(i == 0){
			p0 = p;
		}{
			Pen.moveTo(p0);
			Pen.lineTo(p);
			Color(
				(p.x/bounds.width).clip(0,1),
				1.0-(p.x/bounds.width).clip(0,1),
				(p.y/bounds.height).clip(0,1)
			).set;
			Pen.stroke;
			p0 = p;
		}
	};
};

w = Window("draw on me", Rect(128, 64, 340, 360));

v = UserView(w,w.view.bounds)
	.clearOnRefresh_(false)
	.mouseDownAction_({|v,x,y|
		points = [x@y];
	})
	.mouseMoveAction_({|v,x,y|
		points = points.add(x@y);
		v.refresh;
	})
	.mouseUpAction_({|v,x,y|
		points = points.add(x@y);
		lines = lines.add(points);
		points = nil;
		v.refresh;
	})
	.background_(Color.white)
	.drawFunc_{|me|
		var r = me.bounds;

		Pen.use {
			Pen.width = 1;
			Color.black.set;

			lines.do { |linePoints|
				drawLine.value(linePoints, r);
			};
			lines = nil;

			drawLine.value(points, r);
			if( points.size > 0 ) { points = [points.last] };
		};
	};

w.front;
)
