// Source: Classes/FlowLayout.schelp block 0
(
w = Window.new.front;
//change the gaps and margins to see how they work
w.view.decorator = FlowLayout( w.view.bounds, 10@10, 20@5 );
16.do{ Slider2D( w.view,80@80 ).background_( Color.rand ) };
)
