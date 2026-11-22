// Source: Guides/WritingPrimitives.schelp block 2 (part 1/2)
openUDPPort {|portNum|
	var result;
	if(openPorts.includes(portNum), {^true});
	result = this.prOpenUDPPort(portNum);
	if(result, { openPorts = openPorts.add(portNum); });
	^result;
}
