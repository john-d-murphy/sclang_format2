// Source: Guides/ObjectPrototyping.schelp block 4
(
var makeSpeaker = { |word|
	(
		word: word,
		speak: { |self, adverb| "I say \"%\" %.".format(self.word, adverb) }
	)
};

var cat = makeSpeaker.("meow");
var dog = makeSpeaker.("woof");

cat.speak("loudly").postln; // I say "meow" loudly.
dog.speak("quietly").postln; // I say "woof" quietly.
)
