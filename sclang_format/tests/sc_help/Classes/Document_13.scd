// Source: Classes/Document.schelp block 13
(

//add a mouse action to this document:
//example: easy button:
//when you click in front of a 17 a SinOsc will start up;
s.waitForBoot({
	Document.current.mouseUpAction_({arg doc;
		var char;
		char = doc.rangeText(doc.selectionStart, 2);
		if(char == "17",{
			{EnvGen.kr(Env.perc, doneAction: Done.freeSelf) * SinOsc.ar([600,720,300].choose, 0, 0.5)}.play;
		});
		if(char == "23",{
			{EnvGen.kr(Env.perc, doneAction: Done.freeSelf) * PinkNoise.ar(0.2)}.play;
		});
	})
});
)
