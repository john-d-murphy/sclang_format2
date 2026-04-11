// Source: Guides/GUI-Introduction.schelp block 11
(
var value = 0.5;
w = Window.new.front;

// (1) create a UserView
v = UserView(w,Rect(50,50,200,20));

// (2) define a drawing function using Pen
v.drawFunc = {
	// Draw the fill
	Pen.fillColor = Color.grey;
	Pen.addRect(Rect(0,0, v.bounds.width*value,v.bounds.height));
	Pen.fill;
	// Draw the triangle
	Pen.fillColor = Color.red;
	Pen.moveTo(((v.bounds.width*value)-5) @ v.bounds.height);
	Pen.lineTo(((v.bounds.width*value)+5) @ v.bounds.height);
	Pen.lineTo(((v.bounds.width*value)) @ (v.bounds.height/2));
	Pen.lineTo(((v.bounds.width*value)-5) @ v.bounds.height);
	Pen.fill;
	// Draw the frame
	Pen.strokeColor = Color.black;
	Pen.addRect(Rect(0,0, v.bounds.width,v.bounds.height));
	Pen.stroke;
};

// (3) set the default action
v.action = {value.postln; v.refresh};

// (4) define mouse actions
v.mouseDownAction = { arg view, x = 0.5,y, m;
	//m.postln;
	([256, 0].includes(m)).if{ // restrict to no modifier
	value = (x).linlin(0,v.bounds.width,0,1); v.doAction};
};

v.mouseMoveAction = v.mouseDownAction;

// (5) (optional) define key actions
v.keyDownAction = { arg view, char, modifiers, unicode,keycode;
	if (unicode == 16rF700, { value = (value+0.1).clip(0,1) });
	if (unicode == 16rF703, { value = (value+0.1).clip(0,1) });
	if (unicode == 16rF701, { value = (value-0.1).clip(0,1) });
	if (unicode == 16rF702, { value = (value-0.1).clip(0,1) });
	v.doAction;
};

// (6) (optional) define drag and drop behavior
v.beginDragAction = {value}; // what to drag
v.canReceiveDragHandler = {View.currentDrag.isNumber}; // what to receive
v.receiveDragHandler = {value = View.currentDrag; v.doAction }; // what to do on receiving


// just for testing drag and drop
Slider(w,Rect(50,100,200,20));

StaticText(w,Rect(50,150,350,50)).string_("To Test Drag and Drop,\nHold down Cmd (Ctl) Key");

)
