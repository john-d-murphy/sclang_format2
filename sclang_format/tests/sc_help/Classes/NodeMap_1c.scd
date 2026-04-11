// Source: Classes/NodeMap.schelp block 1 (part 3/13)
(
b = Bus.control(s,1);
x = Synth("modsine");
y = Synth.before(x, "lfo", [\out, b]);
)
