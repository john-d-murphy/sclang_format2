// Source: Classes/FlowLayout.schelp block 4
( //here the third view is fit to both the right and bottom innerBounds
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 20@5 );
Slider2D( w.view,140@140 ).background_( Color.rand );
Slider2D( w.view,140@140 ).background_( Color.rand );
d.nextLine;
Slider2D( w.view, d.indentedRemaining ).background_( Color.rand );
w.front;
)
