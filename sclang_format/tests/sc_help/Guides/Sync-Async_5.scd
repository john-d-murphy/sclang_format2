// Source: Guides/Sync-Async.schelp block 5
play { arg target,args,addAction=\addToTail;
		var synth, msg;
		target = target.asTarget;

		synth = Synth.basicNew(name,target.server); // create a Synth, but not a synth node
		msg = synth.newMsg(target, addAction, args);// make a message that will add a synth node
		this.send(target.server, msg); // ** send the def, and the message as a completion message
		^synth // return the Synth object
	}
