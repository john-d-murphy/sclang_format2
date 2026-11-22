// Source: Classes/SendReply.schelp block 0 (part 8/9)
(
OSCdef(\listener, { |msg|
	var data = msg[3..];
	data.postln;
	~testNetAddr.sendMsg("data", data);
}, '/analysis');
)
