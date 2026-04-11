// Source: Classes/MultiSliderView.schelp block 0
(
n=20;
w = Window.new.front;
m = MultiSliderView(w,Rect(10,10,n*13+2,100)); //default thumbWidth is 13
m.value=Array.fill(n, {|v| v*0.05}); // size is set automatically when you set the value
m.action = { arg q;
    q.value.postln;
};
)
