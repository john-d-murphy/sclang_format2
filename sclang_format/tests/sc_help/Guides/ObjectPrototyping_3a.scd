// Source: Guides/ObjectPrototyping.schelp block 3 (part 1/2)
a = ( speak: {|self... words, kwargs| "I say '%' %.".format(words, kwargs.asDict[\adverb]) } );
