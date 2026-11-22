// Source: Classes/Date.schelp block 3
(
// Simple date/time offsetting can be performed:
("One hundred days before Christmas:" + Date(2010, 12, 25 - 100).format("%B %d")).postln;

// Invalid dates are "corrected"
Date(2017, 2, 29).postln; // March 1: 2017 was not a leap year!
)
