// Source: Classes/CallOnce.schelp block 1 (part 14/22)
(
r = 1; // some resource
c = CallOnce { |releaseResource|
	if(releaseResource) {
		r = r - 1; "Resource is now released:" + r
	} {
		"nothing to do"
	}
};
)
