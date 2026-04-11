// Source: Classes/SemiColonFileReader.schelp block 0 (part 10/15)
(
// write a test file with numbers:
f = File("SemiColonTestNum.sc", "w");

(1..10).do { |n| f.write(n.asString ++ ";"); };
f.close;
)
