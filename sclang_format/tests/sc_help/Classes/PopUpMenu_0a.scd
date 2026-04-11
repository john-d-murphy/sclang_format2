// Source: Classes/PopUpMenu.schelp block 0 (part 1/5)
(
w = Window.new("The Eightfold Path").front;
m = PopUpMenu(w, Rect(10, 10, 180, 20));

m.items = [
 "right view", "right thinking", "right mindfulness", "right speech",
 "right action", "right diligence", "right concentration", "right livelihood"
];

m.background_(Color.green(0.7));  // only changes the look of displayed item
m.stringColor_(Color.white);   // only changes the look of displayed item
m.font_(Font("Courier", 13));   // only changes the look of displayed item
m.action = { arg menu;
 [menu.value, menu.item].postln;
};
)
