// Source: Guides/News-Qt-GUI.schelp block 12
(
var w, e, m;
e = EnvelopeView()
    .value_([
        [0, 0.1, 0.3, 0.4, 0.55, 0.7, 1.0],
        [0, 1.0, 0.7, 0.3, 0.5, 0.2, 0]
    ])
    .keepHorizontalOrder_(true)
    .elasticSelection_(true)
    .front;
m = PopUpMenu()
    .items_(["Elastic Selection", "Rigid Selection"])
    .action_({e.elasticSelection = m.value == 0});
w = Window()
    .layout_(VLayout(m,e))
    .front;
)
