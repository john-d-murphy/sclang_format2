// Source: Classes/Group.schelp block 2 (part 17/19)
(
g.queryTree({ |msg|
	var i = 1, tabs = 0, dumpFunc;
	("NODE TREE Group" + msg[1]).postln;
	if(msg[2] > 0, {
		dumpFunc = { |numChildren|
			tabs = tabs + 1;
			numChildren.do({
				i = i + 3;
				tabs.do({ "   ".post });
				msg[i].post;
				(" " ++ msg[i + 2]).postln;
				if(msg[i + 1] > 0, { dumpFunc.value(msg[i + 1]) });
			});
			tabs = tabs - 1;
		};
		dumpFunc.value(msg[2]);
	});
});
)
