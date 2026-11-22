// Source: Classes/FileReader.schelp block 0 (part 15/16)
(
// write a test file with several lines of numbers:
f = File("FileReadTestNum.sc", "w");

(1..100).do { |n|
	f.write(n.asString ++ if (n % 10 != 0, " ", Char.nl)) };
f.close;
)
