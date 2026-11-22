// Source: Classes/Main.schelp block 5 (part 1/2)
(
f = { |msg, time, replyAddr, recvPort|
	if(msg[0] != '/status.reply') {
		"At time %s received message % from % on port%\n".postf(time, msg, replyAddr, recvPort)
	}
};
thisProcess.addOSCRecvFunc(f);
);
