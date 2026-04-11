// Source: Classes/Plotter.schelp block 0 (part 6/7)
{ var b = Buffer.read(s, Platform.resourceDir +/+ "sounds/SinedPink.aiff"); s.sync; b.plot }.fork(AppClock);
