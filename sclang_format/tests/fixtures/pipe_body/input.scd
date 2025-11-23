(
// pipe body spacing – messy on purpose

// single-line block heads with inline bodies
~f = { |freq = 440, amp = 0.1|SinOsc.ar(freq) * amp};
+~g = { |freq, amp|  Saw.ar(freq) * amp };
~h = { |x, y|x + y};

// multiline heads should not get space before newline
~m = { |freq, amp|
    SinOsc.ar(freq) * amp
};

// blocks without pipes should be untouched
{
    var x = 1;
    x.squared.postln;
}.value;

// strings/comments with pipes should be untouched
"This |should| not change".postln;
// comment: { |x, y|x + y}
)
