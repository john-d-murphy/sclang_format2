// Source: Classes/QuartzComposerView.schelp block 1 (part 73/76)
Event.addEventType(\quartz, { |server|
	var latency = server.latency;
	var view = ~view.postln;
	var key = ~key, value = ~value;
	AppClock.sched(latency, { view.postln; view.setInputValue(key, value) });
});
