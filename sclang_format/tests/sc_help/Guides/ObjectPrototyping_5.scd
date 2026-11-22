// Source: Guides/ObjectPrototyping.schelp block 5
(
var makeSpeaker = {
	var secretWords = "I'm a cat";
	(
		assign_secret: { |self, secret| secretWords = secret },
		speak_secrets: { |self| "My secret is \"%\".".format(secretWords.value) }
	)
};

var p1 = makeSpeaker.();

p1.speak_secrets().postln; // My secret is "I'm a cat".
p1.assign_secret("I'm a dog");
p1.speak_secrets().postln; // My secret is "I'm a dog".
)
