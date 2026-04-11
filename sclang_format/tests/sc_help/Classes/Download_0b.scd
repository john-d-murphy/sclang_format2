// Source: Classes/Download.schelp block 0 (part 2/3)
d = Download("http://scottwilson.ca/files/flame.mp3", "/tmp/flame.mp3", {\huzzah.postln;}, {\error.postln}, {|rec, tot| [rec, tot].postln});
