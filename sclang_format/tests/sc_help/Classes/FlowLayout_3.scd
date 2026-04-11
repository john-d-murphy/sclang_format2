// Source: Classes/FlowLayout.schelp block 3
(
//normally you will only use the width of indentedRemaining
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 20@5 );
Slider2D( w.view,150@150 ).background_( Color.rand );
Slider2D( w.view,150@150 ).background_( Color.rand );
Slider( w.view, d.indentedRemaining.width@150) //fits this view perfectly to the right innerBounds
	.background_( Color.rand );
w.front;
)
