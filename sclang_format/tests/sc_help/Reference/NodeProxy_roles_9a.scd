// Source: Reference/NodeProxy_roles.schelp block 9 (part 1/8)
(
AbstractPlayControl.proxyControlClasses.put(\stream, PatternControl);
AbstractPlayControl.buildMethods.put(\stream,
	#{ arg pattern, proxy, channelOffset=0, index;
		Pbindf(
			pattern,
			\type, \bus,
			\id, Pfunc { proxy.group.nodeID },
			\array, Pkey(\value),
			\out, Pfunc { proxy.index }
		).buildForProxy( proxy, channelOffset, index )
});
)
