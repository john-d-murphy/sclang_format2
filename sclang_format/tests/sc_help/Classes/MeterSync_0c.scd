// Source: Classes/MeterSync.schelp block 0 (part 3/4)
(
m.queryMeter({ |result|
	result.postln;
	m.adjustMeterBase(result[0][\queriedAtBeat], result[0][\beatInBar]);
});
)
