// Source: Classes/Document.schelp block 28
(
Document.listener.background = Color.red;	//a special color for post document
Document.listener.bounds = Rect(1, 461, 620, 567);	//move and resize post document
Document.initAction = {|doc|			//function to run for every new document
	doc.background = Color.grey(0.1, 0.9);
	doc.bounds = Rect(0, 119, 1280, 659);
	doc.selectedBackground = Color(0.4, 0.05, 0.18);
	doc.stringColor = Color.grey(0.9);
};
)
