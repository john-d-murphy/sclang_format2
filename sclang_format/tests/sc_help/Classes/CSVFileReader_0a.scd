// Source: Classes/CSVFileReader.schelp block 0 (part 1/15)
(
// write a test file:
f = File("CSVReadTest.sc", "w");
f.write(
"Some,comma,delimited,items, in line 1

and then, some more, with several commas,,,, in line 3
"
);
f.close;
)
