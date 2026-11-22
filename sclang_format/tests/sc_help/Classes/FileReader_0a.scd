// Source: Classes/FileReader.schelp block 0 (part 1/16)
(
// write a test file:
f = File("FileReaderTest.sc", "w");
f.write(
"Some space delimited items in line 1

and then some more with several blanks     in line 3
"
);
f.close;
)
