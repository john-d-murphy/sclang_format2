// Source: Classes/PathName.schelp block 10
(
var myPath;
myPath = PathName.new("./");
myPath.filesDo{|afile| afile.postln};
)
