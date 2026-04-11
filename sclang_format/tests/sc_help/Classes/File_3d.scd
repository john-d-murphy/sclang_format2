// Source: Classes/File.schelp block 3 (part 4/8)
File.use("~/test.txt".standardizePath, "r", { |f| f.readAllString.postln });
