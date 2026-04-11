// Source: Classes/TabFileReader.schelp block 0 (part 13/14)
(
// write a test file with numbers:
f = File("TabDelTestNum.sc", "w");

(1..100).do { |n|
	f.write(n.asString ++ if (n % 10 != 0, Char.tab, Char.nl)); };
f.close;
)
