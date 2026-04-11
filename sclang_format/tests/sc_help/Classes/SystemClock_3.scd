// Source: Classes/SystemClock.schelp block 3
(
SystemClock.schedAbs( (thisThread.seconds + 4.0).round(1.0),{ arg time;
	("the time is exactly " ++ time.asString
		++ " seconds since starting SuperCollider").postln;
});
)
