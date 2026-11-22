// Source: Classes/Exception.schelp block 4 (part 4/4)
try { } { |error|
	switch(error.species.name)
		{ 'FileNotFoundException' } { postln("File not found:" + e.path) }
		{ 'EmptyFileException' } { postln("File is empty:" + e.path) }
			// default condition: unhandled exception, rethrow
		{ error.throw }
}
