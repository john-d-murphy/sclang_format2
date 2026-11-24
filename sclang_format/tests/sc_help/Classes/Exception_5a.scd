// Source: Classes/Exception.schelp block 5 (part 1/4)
(
~inPlaceSub = { |array, find, replace|
	array.do({ |item, i|
		if(item == find) { array[i] = replace };
	});
};

~trySub = { |array, find, replace|
	try {
		~inPlaceSub.(array, find, replace)
	} { |error|
		switch(error.species.name)
			{ 'PrimitiveFailedError' } {
				if(error.what.find("immutable").notNil) {
					"caught ImmutableError".postln;
					~inPlaceSub.(array.copy, find, replace)
				} { "unknown primitive exception".postln; error.throw }
			}
				// default case: unhandled exception, should die so re-throw error
			{ "unknown exception".postln; error.throw }
	};
};
)
