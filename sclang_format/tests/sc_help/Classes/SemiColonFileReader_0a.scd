// Source: Classes/SemiColonFileReader.schelp block 0 (part 1/15)
(
// write a test file:
f = File("SemiColonTest.sc", "w");
f.write(
"Some semi-colon delimited data;

123;;4;
0.5;0.6;0.7
"
);
f.close;
)
