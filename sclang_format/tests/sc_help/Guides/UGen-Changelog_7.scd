// Source: Guides/UGen-Changelog.schelp block 7
(
// CAUTION: THE FOLLOWING CAN BE EXTREMELY LOUD
// set the following variable to true if you want to run this code
var run = false;
if (run) {
	{ GVerb.ar(Dust.ar(5), SinOsc.kr(0.3).range(10, 14), drylevel:0) }.play
}
// 3.13 super loud glitch (crackling)! 3.14: super loud glitch (cleaner pitch shifting)!
)
