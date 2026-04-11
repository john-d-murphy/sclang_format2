// Source: Guides/News-Qt-GUI.schelp block 3
(
w = Window.new(bounds:Rect(100,100,300,80)).layout_(
    VLayout (
        HLayout(
            Button().states_([["Super"]]),
            TextField().string_("Collider")
        ),
        Button().states_([["SuperCollider"]])
    )
).front;
)
