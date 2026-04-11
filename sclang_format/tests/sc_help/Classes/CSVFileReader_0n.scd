// Source: Classes/CSVFileReader.schelp block 0 (part 14/15)
(
// write a test file with several lines of numbers:
f = File("CSVReadTestNum.sc", "w");

(1..100).do { |n|
	f.write(n.asString ++ if (n % 10 != 0, ",", Char.nl)); };
f.close;
)
