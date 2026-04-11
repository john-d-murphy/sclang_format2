// Source: Classes/SemiColonFileReader.schelp block 0 (part 14/15)
(
// write a test file with numbers:
f = File("SemiColonTestNum.sc", "w");

(1..100).do { |n|
	f.write(n.asString ++ if (n % 10 != 0, $;, Char.nl)); };
f.close;
)
