// Source: Guides/Order-of-execution.schelp block 10 (part 9/9)
(
r.stop;
[~synthgroup, ~fxgroup, b, l, ~lfo, ~xfer].do({ arg x; x.free });
currentEnvironment.clear; // clear all environment variables
)
