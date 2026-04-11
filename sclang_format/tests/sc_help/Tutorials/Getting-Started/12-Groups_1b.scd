// Source: Tutorials/Getting-Started/12-Groups.schelp block 1 (part 2/7)
(
~sources = Group.new;
~effects = Group.after(~sources); 	// make sure it's after
~bus = Bus.audio(s, 2); 		// this will be our stereo effects bus
)
