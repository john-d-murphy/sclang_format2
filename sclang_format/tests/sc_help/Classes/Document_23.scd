// Source: Classes/Document.schelp block 23
(
var doc;
doc = Document.current;
doc.selectRange(doc.selectionStart - 40, 10);
doc.getSelectedLines(doc.selectionStart - 40, 130).postln;
)
