# Permissions Policy and Client Hints

[Draft]

## Background

[Client Hints](https://wicg.github.io/client-hints-infrastructure/) are a
mechanism for the browser to provide information to an origin server about the
browser's configuration and capabilities, to allow the server to select
appropriate responses based on that configuration. See
[here](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/client-hints)
for more information and background on Client Hints specifically.

Client Hints do represent an opportunity for increased fingerprinting surface,
as they expose information about the user's browser, language preferences,
network conditions, and other potentially identifying information. As such, it
is important that the information not be simply made available to all documents
and resources.

[Permissions Policy](https://w3c.github.io/webappsec-permissions-policy/) is a
way to control what features are available in documents, providing a method of
delegation of powerful features to subframes.

## Relationship between Permissions Policy and Client Hints

Every client hint is represented in Permissions Policy as a policy-controlled
feature. The feature, which is always enabled at the top-level, represents the
ability to receive the hint in a subframe.

There are two broad classes of hints defined: High-entropy and Low-entropy. High
entropy hints contain a greater amount of potententially identifying information
about the user, and are not intended for automatic distribution to cross-origin
resources. Low entropy hints contain information about the browser which is
expected to be consistent across large groups of users (browser name, or major
version, for instance) and is much less useful for identifying individual users.

High-entropy hints are backed by features with a default allowlist of `self`.
Low-entropy hints are backed by features with a default allowlist of `*`.

Example high-entropy hints (and their corresponding features):
    * DPR (`ch-dpr`)
    * UA-Arch (`ch-ua-arch`)

Example low-entropy hints (and their corresponding features):
    * Save-Data (`ch-save-data`)
    * UA (`ch-ua`)

## How delegation works

In top-level documents, hints are requested with the Accept-CH HTTP response
header [ref](https://tools.ietf.org/html/draft-ietf-httpbis-client-hints-15).

### Delegation to embedded documents

Any document which receives hints may choose to delegate those hints to other
documents which it embeds inside of an `<iframe>` element.

By default, low-entropy hints are sent to all embedded documents, while
high-entropy hints are only sent if the embedded document is same-origin with
its embedder [Example 1](#example-1). The iframe's `allow` attribute is used to
name specific hints which should be sent to the embedded document
[Example 2](#example-2).

Question: Does the embeddded document's Accept-CH header affect this processing
at all?

If an embedded document is same-origin with its embedder, then Permissions
Policy will delegate all available hints by default. In that case, the allow
attribute can still be useful, both for restricting hints which would otherwise
be sent [Example 3](#example-3), and also for controlling hints when the iframe
is navigated away from its initial origin [Example 4](#example-4).

The `Permissions-Policy` header is also considered when delegating hints to
embedded documents. If a hint is named in a document's `Permissions-Policy`
header, then the corresponding allowlist is also checked, and the embedded
document's origin must *also* be included in that list in order for it to be
sent hints [Example 5](#example-5).

Note that any hints which were not sent to a document *cannot* be sent to any
documents which it embeds.

### Delegation to subresources

Client hints are also sent for subresource requests from a document, for
resources such as images, stylesheets and scripts. The elements used to embed
these resources (`<img>`, `<link>` and `<script>` elements) do not support an
`allow` attribute, and so the processing is slightly different in this case.

For hints to be sent to an origin server for a subresource request, the
`Permissions-Policy` header is checked in every case. By default, any
low-entropy hints with the embedding document received will be sent with all
requests, while high-entropy hints are only sent if the resource is same-origin
with the document [Example 6](#example-6).

By using the `Permissions-Policy` header, it is possible to name the origins for
which subresrouces should (or by omission, should not) receive hints
[Example 7](#example-7).

Note that any hints which were not sent to the document in the first place
*cannot* be sent with any subresource requests, regardless of origin.

## Examples

[Incoming]
