// Source: Classes/Function.schelp block 10 (part 3/3)
(
fork { // schedules on a TempoClock
    { "chicken".postln }.defer // schedules on the AppClock
};
{ "egg".postln }.defer // evaluates immediately
)
