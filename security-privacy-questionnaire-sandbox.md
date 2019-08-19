# Security and Privacy questionnaire for feature policy control over iframe sandbox features

4.1. What information might this feature expose to Web sites or other parties, and for what purposes
is that exposure necessary?”

* If coupled with the JavaScript introspection API for feature policy, this feature will allow
sandboxed websites to determine exactly which sandbox features have been applied to them (assuming
that they do not have the [sandboxed scripts browsing context
flag](https://html.spec.whatwg.org/#sandboxed-scripts-browsing-context-flag) set). This
is for consistency with the rest of the JS API, which allows sites to inspect their feature policy.

In practice, this would allow sites to detect the availability of features such as HTML form
submission, without having to try to use it first and catch exceptions, possibly allowing for better
UI and user experience.

As currently designed, this will also integrate with reporting, feature policy features can generally
trigger reporting on violation. 

4.2. Is this specification exposing the minimum amount of information necessary to power the feature?

Technically no (as mentioned above), but it would require special-casing these features, separately
from all other policy-controlled features, in order to change that.

4.3. How does this specification deal with personal information or personally-identifiable information
or information derived thereof?

N/A

4.4. How does this specification deal with sensitive information?

N/A

4.5. Does this specification introduce new state for an origin that persists across browsing sessions?

No.

4.6. What information from the underlying platform, e.g. configuration data, is exposed by this
specification to an origin?

None.

4.7. Does this specification allow an origin access to sensors on a user’s device

No.

4.8. What data does this specification expose to an origin? Please also document what data is identical
to data exposed by other features, in the same or different contexts.

See 4.1. When coupled with the JS API, this directly exposes the active sandbox flags, which can generally
be inferred by scripts with more awkward feature detection mechanisms.

4.9. Does this specification enable new script execution/loading mechanisms?

No.

4.10. Does this specification allow an origin to access other devices?

No.

4.11. Does this specification allow an origin some measure of control over a user agent’s native UI?

No.

4.12. What temporary identifiers might this this specification create or expose to the web?

None.

4.13. How does this specification distinguish between behavior in first-party and third-party contexts?

Exactly as sandboxing, and feature control currently do. Sandboxed frames have an opaque origin by default,
which is third-party to all other frames. Sandboxing and feature policy allow selective control over which
powerful features are provided to each such frame.

4.14. How does this specification work in the context of a user agent’s Private \ Browsing or "incognito" mode?

Exactly as it does in non-private modes.

4.15. Does this specification have a "Security Considerations" and "Privacy Considerations" section?

It will, once written as a proper spec.

4.16. Does this specification allow downgrading default security characteristics?

This specification provides another mechanism for sandboxed frames to be granted access to certain features,
but not any more than already exists with the iframe sandbox attribute. It also allows non-sandboxed frames
to be denied access to these features.

4.17. What should this questionaire have asked?

I'll get back to you on that.
