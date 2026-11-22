// Source: Classes/Bus.schelp block 6 (part 11/36)
(
a = "waiting";
b.get({ |value| a = value; ("after the server responds a is set to:" + a).postln });
("a is now:" + a).postln;
)
