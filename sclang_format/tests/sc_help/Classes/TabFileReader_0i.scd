// Source: Classes/TabFileReader.schelp block 0 (part 9/14)
(
// write a test file with numbers:
f = File("TabDelTestNum.sc", "w");

(1..10).do { |n| f.write(n.asString ++ Char.tab); };
f.close;
)
