// Source: Guides/Understanding-Errors.schelp block 20
(
Routine({
    var func;
    func = {
        var synth; // this variable is local to the function
        synth = Synth("default");
        [\play, synth].postln;
        thisThread.clock.sched(4.5, {
            synth.free;
        	[\free, synth].postln;
        });
    };
    { func.value; 1.wait; }.loop
}).play;
)
