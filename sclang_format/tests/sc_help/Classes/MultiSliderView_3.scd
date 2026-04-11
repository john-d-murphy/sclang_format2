// Source: Classes/MultiSliderView.schelp block 3
(
// press shift to extend the selection
// use as waveView: scrubbing over the view returns index
// if showIndex(false) the view is not refreshed (faster);
// otherwise you can make a selection with shift - drag.
var size, file, maxval, minval;
size = 640;
a = Window("test", Rect(200 , 140, 650, 150));
a.view.decorator = FlowLayout(a.view.bounds);
b = MultiSliderView(a, Rect(0, 0, size, 50));
b.readOnly_(true);
a.view.decorator.nextLine;

d = Array.new;
c = FloatArray.newClear(65493);

r = Slider( a, Rect(0, 0, size, 12));
r.action = {arg ex; b.gap = (ex.value * 4) + 1};

file = SoundFile.new;
file.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
file.numFrames.postln;
file.readData(c);
// file.inspect;
file.close;
minval = 0;
maxval = 0;
f = Array.new;
d = Array.new;
c.do({arg fi, i;
    if(fi < minval, {minval = fi});
    if(fi > maxval, {maxval = fi});

    //f.postln;
    if(i % 256 == 0,{
        d = d.add((1 + maxval ) * 0.5 );
        f = f.add((1 + minval ) * 0.5 );

        minval = 0;
        maxval = 0;
    });
});

b.reference_(d); // this is used to draw the upper part of the table
b.value_(f);

r = Slider( a, Rect(0, 0, size, 12));
r.action = {arg ex; b.startIndex = ex.value *f.size};

// b.enabled_(false);
b.action = {arg xb; ("index: " ++ xb.index).postln};
b.drawLines_(true);
b.drawRects_(false);
b.isFilled_(true);
b.selectionSize_(10);
b.index_(10);
b.thumbSize_(1);
b.gap_(0);
b.colors_(Color.black, Color.blue(1.0,1.0));
b.showIndex_(true);
a.front;

)
