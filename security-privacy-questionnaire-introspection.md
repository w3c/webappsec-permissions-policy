# Security and Privacy questionnaire for the JavaScript Introspection API

3.1 Does this specification deal with personally-identifiable information?

* NO

3.2 Does this specification deal with high-value data?

* NO

3.3 Does this specification introduce new state for an origin that persists
across browsing sessions?

* NO

3.4 Does this specification expose persistent, cross-origin state to the web?

* NO

3.5 Does this specification expose any other data to an origin that it doesn’t
currently have access to?

* This API exposes the set of features which are allowed in the current
  document, which is at least partially determined by its embedder, which may
  be cross-origin. However, the availability of these features is generally
  always something which can be determined by the document already, through
  feature detection. If there was a policy-controlled feature whose availability
  could not otherwise be detected (No execptions thrown, no new global symbols
  available; no observable behaviour change at all,) then this API could allow
  the document to see whether such a feature was disallowed by its embedder.

3.6 Does this specification enable new script execution/loading mechanisms?

* NO

3.7 Does this specification allow an origin access to a user’s location?

* NO. It grants an origin the ability to tell whether such access has been
  explicitly blocked, in which case the origin can know not even to bother
  requesting permission.

3.8 Does this specification allow an origin access to sensors on a user’s
device?

* NO. As above, it does allow the origin to tell whether such access is even
  potentially available, or whether it has been blocked by policy.

3.9 Does this specification allow an origin access to aspects of a user’s local
computing environment?

* NO

3.10 Does this specification allow an origin access to other devices?

* Again, no. (And see 3.7, the same note applies.)

3.11 Does this specification allow an origin some measure of control over a user
agent’s native UI?

* NO

3.12 Does this specification expose temporary identifiers to the web?

* NO

3.13 Does this specification distinguish between behavior in first-party and
third-party contexts?

* YES. The specification for this API introduces the concept of an "observable
  policy" for an iframe, which contains only the information that the embedding
  document already has about the policy which would be applied to a document in
  that iframe. Any behaviour of the document in the frame (such as a
  `Feature-Policy` header being delivered with it, or navigations made by that
  frame) are not visible to the embedding document.

3.14 How should this specification work in the context of a user agent’s
"incognito" mode?

* There should be no difference between regular and private/incognito browsing
  behaviours.

3.15 Does this specification persist data to a user’s local device?

* NO

3.16 Does this specification have a "Security Considerations" and "Privacy
Considerations" section?

* YES, and this has been updated with some notes about the JS API.

3.17 Does this specification allow downgrading default security characteristics?

* This API does not allow any modification of a document's security
  characteristics. It is for observation of policies only.
