// Source: Classes/ListView.schelp block 0
(
w = Window.new.front;

v = ListView(w, Rect(10, 10, 120, 70))
    .items_(["SinOsc", "Saw", "LFSaw", "WhiteNoise", "PinkNoise", "BrownNoise", "Osc"])
    .background_(Color.clear)
    .hiliteColor_(Color.green(alpha: 0.6))
    .action_({ |sbs|
        [sbs.value, v.items[sbs.value]].postln; // .value returns the integer
   });
)
