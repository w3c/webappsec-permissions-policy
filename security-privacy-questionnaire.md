3.1 Does this specification deal with personally-identifiable information?

* NO

3.2 Does this specification deal with high-value data?

* NO

3.3 Does this specification introduce new state for an origin that persists across browsing sessions?

* NO

3.4 Does this specification expose persistent, cross-origin state to the web?

* NO

3.5 Does this specification expose any other data to an origin that it doesn’t currently have access to?

* In its current state, no, the specification does not expose any new data to origins. Future changes being considered for this spec include:

 * a violation reporting api, which will have to be handled carefully to ensure that parent frames cannot infer any sensitive information about their children based on reported policy violations
 * A JavaScript-based policy introspection API, which would give an origin access to the policy which was granted it by its parent frame.

3.6 Does this specification enable new script execution/loading mechanisms?

* NO

3.7 Does this specification allow an origin access to a user’s location?

* Not directly, and in fact, it gives developers new and exciting ways to *disallow* an origin access to a user’s location.

3.8 Does this specification allow an origin access to sensors on a user’s device?

* Similarly, no. New methods to control access to sensors (such as camera and microphone) are provided by this specification.

3.9 Does this specification allow an origin access to aspects of a user’s local computing environment?

* NO

3.10 Does this specification allow an origin access to other devices?

* Again, no. However, we expect that it will be used to control access to other devices as well.

3.11 Does this specification allow an origin some measure of control over a user agent’s native UI?

* NO

3.12 Does this specification expose temporary identifiers to the web?

* NO

3.13 Does this specification distinguish between behavior in first-party and third-party contexts?

* YES. One function of Feature Policy is to specify a way for features to behave in different ways in first-party and third-party contexts. It makes it easy to specify, for instance, that a feature like payments, should be allowed in top-level documents and their same-origin frames, but disallowed by default in any cross-origin frames.

3.14 How should this specification work in the context of a user agent’s "incognito" mode?

* There should be no difference between regular and private/incognito browsing behaviours.

3.15 Does this specification persist data to a user’s local device?

* NO

3.16 Does this specification have a "Security Considerations" and "Privacy Considerations" section?

* It’s a TODO, getting todone very soon.

3.17 Does this specification allow downgrading default security characteristics?

* Yes. This specification allows a frame with access to a feature to grant that access to a cross-origin child frame which would not normally have  it. However, this is entirely under the control of the parent document, and does not grant any fundamentally new capabilities. Without Feature Policy, a cooperating parent and child could always use other mechanisms, like postMessage, or out-of-band means, to communicate and have the parent perform any actions on behalf of the child.
