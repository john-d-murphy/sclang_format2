// Source: Classes/Poll.schelp block 0 (part 12/13)
(
x = {|t_poll=0|
var minfreq, maxfreq, son;
minfreq = LFNoise2.ar(0.25, 100, 110);
maxfreq = LFNoise2.ar(0.25, 200, 220);

son = Gendy1.ar(minfreq: minfreq, maxfreq: maxfreq, mul: 0.1);

Poll.kr(t_poll, [minfreq, maxfreq], ["minfreq", "maxfreq"]);

son;

}.play(s);
)
