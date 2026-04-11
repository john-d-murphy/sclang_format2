// Source: Classes/UserView.schelp block 8
(
var width = 640, height = 480, w, theta = 0, drawFunc;
w = Window( "trails", Rect( 128, 64, width, height ), false );
drawFunc = { arg view;
	var x = 20 * sin( theta ), y = 42 * cos( theta );
	theta = theta + 0.01;
	//draw a semitransparent rect filling the screen:
	Pen.fillColor_( Color.red( 0.2, 0.1 ));
	Pen.fillRect( Rect( 0, 0, width, height ));
	Pen.strokeColor_( Color.white );
	Pen.translate( width * 0.5, height * 0.5 );
	6.do { arg i;
		Pen.rotate( theta * (1 - (i / 6)) );
		Pen.scale( 0.7 + (i * 0.4), 0.4 + (i * 0.5) );
		Pen.strokeOval( Rect.aboutPoint( Point( x, y ), 60, 40 ));
	};
};
x = UserView( w, Rect( 10, 10, width - 20, height - 20 ))
	.canFocus_( false )
	.drawFunc_( drawFunc )
	.clearOnRefresh_( false );

w.front;
x.animate = true
)
