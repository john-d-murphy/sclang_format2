// Source: Classes/String.schelp block 58
(
// same as File-readAllStringRTF
g = File("/code/SuperCollider3/build/Help/UGens/Chaos/HenonC.help.rtf", "r");
g.readAllString.stripRTF.postln;
g.close;
)
