// Source: Classes/Date.schelp block 8
(
var savedDateStr = Date.localtime.format("%Y%m%d_%H%M%S").postcs;
var loadedDate = Date.fromString(savedDateStr, "%Y%m%d_%H%M%S").postln;
)
