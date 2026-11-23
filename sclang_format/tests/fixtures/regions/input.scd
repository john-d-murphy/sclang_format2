// A file of regions: each is evaluated by itself from the editor, and sclang
// refuses the file read whole. Each is formatted as the program it is.
s.boot

(
SynthDef(\ping,{|freq=440,amp=0.1|
var snd=SinOsc.ar(freq)*Env.perc(0.01,0.3).ar(Done.freeSelf);
Out.ar(0,snd*amp!2)
}).add;
)

// Loose lines that are no program together are left as they are written.
x=Synth(\ping)
x.free ;

(
var notes=[60,62,64,65,67,69,71,72],wait=0.25;
Routine({notes.do{|note|Synth(\ping,[freq:note.midicps,amp:0.2]);wait.wait}}).play;
);

// Loose lines that are a program are formatted as one.
y=Synth(\ping,[freq:660,amp:0.2]);
  y.free ;

// Two lines to evaluate one at a time, which read together as one call: left.
z.play
(1..3).do{|i|i.postln}

(
// A `(` that begins a line inside a region opens no region of its own.
~chord={|root|
(
freq:(root+[0,4,7]).midicps,
sustain:2
).play
};
) // and this comment stays where it is
