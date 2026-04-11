// Source: Classes/Env.schelp block 27
(
{
e = Env.sine.asStream;
5.do({
	e.next.postln;
	0.25.wait;
})}.fork
)
