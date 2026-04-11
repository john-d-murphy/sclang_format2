// Source: Classes/Object.schelp block 0 (part 1/3)
(
a = Array.fill(100, { 100.rand });
a.writeArchive(PathName.tmp ++ "myArray");
b = Object.readArchive(PathName.tmp ++ "myArray");
a == b; // true
)
