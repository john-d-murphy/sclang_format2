// Source: Classes/StackLayout.schelp block 0
(
var stack;
w = Window().layout_(VLayout(
    Button().states_([["One"], ["Two"], ["Three"]]).action_({ |b| stack.index = b.value }),
    stack = StackLayout(
        TextView().string_("This is a chunk of text..."),
        TextView().string_("...and this is another..."),
        TextView().string_("...and another.")
    );
)).front;
)
