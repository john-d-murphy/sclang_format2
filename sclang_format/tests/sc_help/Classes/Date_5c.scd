// Source: Classes/Date.schelp block 5 (part 3/3)
(
// Round-trip via string, using "stamp"
var stampString = Date(2013, 5, 25, 10, 9, 8).stamp;
var d = Date.fromString(stampString, "%y%m%d_%H%M%S");
(stampString + "-->" + d).postln;
)
