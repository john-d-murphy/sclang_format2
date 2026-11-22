// Source: Tutorials/GUI/compose_complex_view.schelp block 2
(
var tabView = UserView();
var stackLayout = StackLayout();
var buttonLayout = HLayout();

var tabNames = [
	"Tab One",
	"Tab Two",
	"Tab Three"
];
var tabs = List(0);

tabNames.do({ |tabName, tabIndex|
	var button = Button()
	.string_(tabName)
	// Map the button to the stackLayout index:
	.action_({ stackLayout.index_(tabIndex); });

	// Tabs are created here
	// because it is only an example.
	// In real code,
	// your views have likely
	// been created before.
	var tab = UserView()
	.background_(Color.rand);

	buttonLayout.add(button);
	stackLayout.add(tab);
});

// Allows to specify the starting tab
stackLayout.index_(0);

tabView.layout_(
	VLayout()
	.add(buttonLayout, 1)
	.add(stackLayout, 9)
);

tabView.front;
)
