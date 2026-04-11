// Source: Classes/FlowLayout.schelp block 5
(
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 20@5 );
Slider2D( w.view,150@150 ).background_( Color.rand );
d.left_(220); //manually set the new indentation
Slider2D( w.view,150@150 ).background_( Color.rand );
w.front;
)
