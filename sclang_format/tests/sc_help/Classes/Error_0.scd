// Source: Classes/Error.schelp block 0
(
var file, path = "betcha-this-file-doesnt-exist.txt";
if((file = File(path, "r")).isOpen) {
	"File is % bytes long.\n".postf(file.length);
	file.close;
} {
	Error("File % could not be opened.".format(path)).throw;
};
)
