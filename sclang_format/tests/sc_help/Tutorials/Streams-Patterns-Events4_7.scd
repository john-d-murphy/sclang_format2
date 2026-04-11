// Source: Tutorials/Streams-Patterns-Events4.schelp block 7
(
var a;
a = Environment.make({
	~a = 10;
	~b = 200;
	~c = 3000;
});
a.use({
	~a + ~b + ~c
}).postln;
)
