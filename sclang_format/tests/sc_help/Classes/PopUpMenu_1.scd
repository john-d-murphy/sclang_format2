// Source: Classes/PopUpMenu.schelp block 1
(
s.waitForBoot({

 var w, menu, snd, funcs, b;

 w = Window.new.front;

 menu = PopUpMenu(w, Rect(10, 10, 90, 20))
  .items_(["Sine", "Saw" , "Noise" , "Pulse"]);

 funcs = [
  { SinOsc.ar(440, 0, 0.3) },
  { Saw.ar(440, 0.3) },
  { WhiteNoise.ar(0.3) },
  { Pulse.ar(440, 0.2, 0.3) }
 ];

 b = Button(w, Rect(110, 10, 180, 20))
  .states_([["play", Color.black, Color.green]])
  .mouseDownAction_({
    snd = funcs.at(menu.value).play;
   })
  .action_({ arg butt, mod;
    snd.release;
   });

 w.front;

 p = CmdPeriod.add({ b.value_(0) }); // set button to 0 on hitting Cmd-period
 w.onClose_{ snd.release; CmdPeriod.removeAll }; // clean up when window is closed

})
)
