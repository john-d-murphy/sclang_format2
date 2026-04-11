// Source: Classes/View.schelp block 2 (part 2/3)
a.action = { |a|
		a.palette = a.palette.buttonText_( if(a.value > 0.5){Color.red}{Color.green} );
	};
