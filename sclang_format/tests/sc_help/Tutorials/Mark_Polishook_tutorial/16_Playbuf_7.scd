// Source: Tutorials/Mark_Polishook_tutorial/16_Playbuf.schelp block 7
(
 ~theSource.set(\rateScale, 0.95.rrand(1.05), \mul, 0.051.rrand(0.07));
 ~fx1.set(\modFreq, 800.0.rrand(1200));
 ~fx2.set(\freq, 500.rrand(700), \freqDev, 180.rrand(210), \boost, 7);
)
