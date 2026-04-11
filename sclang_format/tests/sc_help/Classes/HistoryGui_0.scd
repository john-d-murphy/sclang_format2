// Source: Classes/HistoryGui.schelp block 0
(
// create a short history
h = History([
	[0, \me, "1+2"],
	[1, \me, "3+5"], [1.234, \you, "q = q ? ();"],
	[3, \they, "\"The story\".speak"]
]);
// make a gui for it
g = h.makeWin(0@20);
// find or make a text window for code line display
// (called 'doc' because that was a Document in pre-Qt times)
g.findDoc;
// post line at index 2 in h.lines in doc window
g.postDoc(2);
)
