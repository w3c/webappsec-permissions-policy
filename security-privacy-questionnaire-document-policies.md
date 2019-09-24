# Security and Privacy questionnaire for [Document Policies](https://github.com/w3c/webappsec-feature-policy/blob/master/document-policy-explainer.md)

### 2.1 What information might this feature expose to Web sites or other parties, and for what purposes is that exposure necessary?

When requested by an embedding page, this feature exposes to an origin server
the restrictions which an embedded document must adhere to in order to be
loaded into an iframe. This is necessary because enforcing some restrictions
may introduce security issues in documents which are not aware of the
existance of Document Policies (or which are aware, and do not consent to
those particular restrictions)

### 2.2 Is this specification exposing the minimum amount of information necessary to power the feature?
I believe so.

### 2.3 How does this specification deal with personal information or personally-identifiable information or information derived thereof?
This specification does not deal with such information.

### 2.4 How does this specification deal with sensitive information?
This specification does not deal with such information.

### 2.5 Does this specification introduce new state for an origin that persists across browsing sessions?
No. No information persists longer than the lifetime of a document.

### 2.6 What information from the underlying platform, e.g. configuration data, is exposed by this specification to an origin?
None.

### 2.7 Does this specification allow an origin access to sensors on a user’s device?
No, that should be within the purview of [Feature Policy](https://w3c.github.io/webappsec-feature-policy/) instead.

### 2.8 What data does this specification expose to an origin? Please also document what data is identical to data exposed by other features, in the same or different contexts.
See 2.1. When requested by an embedding page, this feature exposes to an origin
server the restrictions which an embedded document must adhere to in order to be
loaded into an iframe.

### 2.9 Does this specification enable new script execution/loading mechanisms?
No, but it may allow for restriction of existing script execution and loading
mechanisms.

### 2.10 Does this specification allow an origin to access other devices?
No, that should be within the purview of [Feature Policy](https://w3c.github.io/webappsec-feature-policy/) instead.

### 2.11 Does this specification allow an origin some measure of control over a user agent’s native UI?
No.

### 2.12 What temporary identifiers might this this specification create or expose to the web?
None.

### 2.13 How does this specification distinguish between behavior in first-party and third-party contexts?
Currently it does not, although there is an open question as to whether first-party subframes should automatically accept the policies imposed by their parent frames.

It does, however, exhibit that behaviour for srcdoc and data: urls, which are completely controlled by the parent frame.

### 2.14 How does this specification work in the context of a user agent’s Private Browsing or "incognito" mode?
There should be no change in behaviour at all.

### 2.15 Does this specification have a "Security Considerations" and "Privacy Considerations" section?
Not yet, it's just an explainer.

### 2.16 Does this specification allow downgrading default security characteristics?
No.

### 2.17 What should this questionnaire have asked?
