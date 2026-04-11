// Source: Classes/Plotter.schelp block 17 (part 13/15)
a = { SinOsc.ar([700, 357] *0.02) * SinOsc.ar([400, 476]) * 0.3 }.plot(0.2, minval: -1);

// Env:plot
Env.perc(0.4, 0.6).plot;
