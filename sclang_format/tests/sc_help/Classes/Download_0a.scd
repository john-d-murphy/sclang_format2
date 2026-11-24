// Source: Classes/Download.schelp block 0 (part 1/2)
(
var url = "https://scottwilson.ca/files/flame.mp3";
var localPath = Platform.defaultTempDir +/+ url.split($/).last;

d = Download(
	url,
	localPath,
	{
		"downloaded to %".format(localPath).postln;
	},
	{
		"error".postln;
	},
	{ |receivedBytes, totalBytes|
		"Downloaded %\\%".format((receivedBytes/totalBytes*100.0).round(1e-2)).postln;
	},
);
)
