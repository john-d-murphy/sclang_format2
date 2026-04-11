// Source: Classes/Knob.schelp block 1
(
var view = View().layout_(
    HLayout(
        VLayout(Knob().mode_(\round), StaticText().string_("round")),
        VLayout(Knob().mode_(\vert), StaticText().string_("vert")),
        VLayout(Knob().mode_(\horiz), StaticText().string_("horiz"))
    )
);
view.front;
)
