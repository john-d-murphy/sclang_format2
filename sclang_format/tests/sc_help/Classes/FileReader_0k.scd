// Source: Classes/FileReader.schelp block 0 (part 11/16)
(
// write a test file with numbers:
f = File("FileReadTestNum.sc", "w");

(1..10).do { |n| f.write(n.asString ++ " ") };
f.close;
)
