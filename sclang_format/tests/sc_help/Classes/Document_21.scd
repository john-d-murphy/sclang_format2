// Source: Classes/Document.schelp block 21
(
var doc;
doc = Document.current;
doc.selectRange(doc.selectionStart - 40, 10);
doc.selectedString.postln;
)
