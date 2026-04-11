// Source: Classes/Thunk.schelp block 2 (part 5/6)
a = { \done1.postln; Array.fill(10000, { |i| i + 6 % 5 * i / 2 }) }; // some calculation.
b = { \done2.postln;Array.fill(10000, { |i| i + 5 % 6 * i / 3 }) };// some other calculation.
c = [a, b].choose + 700;
