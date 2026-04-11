// Source: Classes/TabFileReader.schelp block 0 (part 1/14)
(
// write a test file:
f = File("TabDelTest.sc", "w");
f.write(
"Some	tab-	delimited	items	in	line	1

and	then	some	more	in	line	3
"
);
f.close;
)
