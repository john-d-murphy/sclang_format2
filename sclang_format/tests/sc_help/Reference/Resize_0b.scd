// Source: Reference/Resize.schelp block 0 (part 2/2)
(
w = Window("soundfile test", Rect(200, 200, 720, 250));

p = PopUpMenu(w, Rect(10,10,80,24))
	.items_( Array.fill(9, {arg i; (i+1).asString;}) )
	.action_({ arg sbs;
		a.resize_(sbs.value+1);
	});

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");

a = SoundFileView(w, Rect(10,40, 700, 180))
	.soundfile_(f)
	.readWithTask(0, f.numFrames, showProgress: false )
	.resize_(1);

w.front;
)
