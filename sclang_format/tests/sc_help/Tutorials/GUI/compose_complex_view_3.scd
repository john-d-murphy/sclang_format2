// Source: Tutorials/GUI/compose_complex_view.schelp block 3
(
var window = Window(
	"Visibility Toggle",
	Rect(100, 100, 600, 400)
);

// Our main display
var mainView = UserView()
.layout_(HLayout());

// Restricting max height
// because it is only a menu
var visibilityView = UserView()
.maxHeight_(64)
.layout_(HLayout());

// We reference the
// number of hidden views
// to hide the 'visibility menu'
// when no views are hidden
var numberOfHiddenView = 0;

// A multiSlider example
var multiSliderView;
var multiSliderHideButton;
var multiSliderShowButton;
var multiSlider;

// A text example
var textView;
var textHideButton;
var textShowButton;
var text;

// Setup the multiSlider view
multiSliderView = UserView()
.layout_(VLayout());

multiSlider = MultiSliderView()
.value_([1, 2, 3, 4, 5, 6, 7, 8].reciprocal)
.drawLines_(true)
.elasticMode_(1);

multiSliderHideButton = Button()
.string_("Hide MultiSlider")
.maxHeight_(64);

// Show button is not visible on startup
multiSliderShowButton = Button()
.visible_(false)
.string_("Show MultiSlider")
.maxHeight_(64);

multiSliderView.layout.add(
	multiSliderHideButton, 1);
multiSliderView.layout.add(
	multiSlider, 9);

// Insert the subview into the main view
mainView.layout.add(multiSliderView, 1);
// Add the 'show' button to the visibility view
visibilityView.layout.add(multiSliderShowButton);

// Setup the text view
textView = UserView()
.layout_(VLayout());

text = StaticText()
.string_("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam.")
.align_(\center);

textHideButton = Button()
.string_("Hide Text")
.maxHeight_(64);

// Show button is not visible on startup
textShowButton = Button()
.visible_(false)
.string_("Show Text")
.maxHeight_(64);

textView.layout.add(
	textHideButton, 1);
textView.layout.add(
	text, 9);

// Insert the subview into the main view
mainView.layout.add(textView, 1);
// Add the 'show' button to the visibility view
visibilityView.layout.add(textShowButton);

// Constructing the top level
window.layout_(
	VLayout()
	.add(mainView)
	.add(visibilityView)
);

// Hide the visibility view,
// because everything is visible at start
visibilityView.visible_(false);


// --- Here's the visibility logic: ---
// When the hide button is pressed
multiSliderHideButton.action_({
	// Hide the view
	multiSliderView.visible_(false);
	// Set the show button visible
	multiSliderShowButton.visible_(true);
	// Increment the number of hidden views
	numberOfHiddenView = numberOfHiddenView + 1;
	// If exactly one item is hidden,
	// this means we have to show the visibility view
	// which was previously hidden
	if(numberOfHiddenView == 1)
	{ visibilityView.visible_(true); };
});

// Now the inverse for the show button:
// When the show button is pressed
multiSliderShowButton.action_({
	// Show the view
	multiSliderView.visible_(true);
	// Hide the show button
	multiSliderShowButton.visible_(false);
	// Decrement the number of hidden views
	numberOfHiddenView = numberOfHiddenView - 1;
	// If there is no hidden item,
	// hide the visibility view
	if(numberOfHiddenView == 0)
	{ visibilityView.visible_(false); };
});

// Same for the text view:
textHideButton.action_({
	textView.visible_(false);
	textShowButton.visible_(true);
	numberOfHiddenView = numberOfHiddenView + 1;
	if(numberOfHiddenView == 1)
	{ visibilityView.visible_(true); };
});

textShowButton.action_({
	textView.visible_(true);
	textShowButton.visible_(false);
	numberOfHiddenView = numberOfHiddenView - 1;
	if(numberOfHiddenView == 0)
	{ visibilityView.visible_(false); };
});

// Done
window.front;
)
