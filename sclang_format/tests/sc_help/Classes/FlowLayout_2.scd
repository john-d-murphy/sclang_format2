// Source: Classes/FlowLayout.schelp block 2
(
w = Window.new;
q = w.addFlowLayout( 10@10, 20@5 );
Slider2D( w.view,140@140 ).background_( Color.rand );
q.nextLine;
Slider2D( w.view,140@140 ).background_( Color.rand );
w.front;
)
