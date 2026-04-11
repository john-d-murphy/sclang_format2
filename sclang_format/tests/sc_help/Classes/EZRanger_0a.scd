// Source: Classes/EZRanger.schelp block 0 (part 1/2)
(
w = Window.new.front;
g = EZRanger(w, 400@16," test  ", \freq, { |v| v.value.postln }, [50,2000], unitWidth:30)
)
