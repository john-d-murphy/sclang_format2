// Source: Classes/CSVFileReader.schelp block 0 (part 10/15)
(
// write a test file with numbers:
f = File("CSVReadTestNum.sc", "w");

(1..10).do { |n| f.write(n.asString ++ ","); };
f.close;
)
