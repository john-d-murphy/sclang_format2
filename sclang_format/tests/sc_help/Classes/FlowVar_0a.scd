// Source: Classes/FlowVar.schelp block 0 (part 1/2)
(
a = FlowVar.new;
fork {
	"I am waiting, please enter a value ...".postln;
	a.value.postln;
	"...... ok, done.".postln;
}
)
