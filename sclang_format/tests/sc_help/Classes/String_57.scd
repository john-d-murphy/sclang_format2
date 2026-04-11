// Source: Classes/String.schelp block 57
(
// same as File-readAllStringRTF
g = File("/code/SuperCollider3/build/Help/UGens/Chaos/HenonC.help.rtf","r");
g.readAllString.stripRTF.postln;
g.close;
)
