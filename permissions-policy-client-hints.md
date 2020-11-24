# Permissions Policy and Client Hints

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
feature. The feature, which is always enabled for top-level documents,
represents the ability to receive the hint in a subframe.

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
header
([reference](https://tools.ietf.org/html/draft-ietf-httpbis-client-hints-15)).

Permissions Policy cannot be used to change the hints received by the top-level
document, as the `Permissions-Policy` response header cannot be sent before the
hints (which are request headers) are received. However, it can be used to
control where those hints are sent after that.

### Delegation to embedded documents

Any document which receives hints may choose to delegate those hints to other
documents which it embeds inside of an `<iframe>` element.

By default, low-entropy hints are sent to all embedded documents, while
high-entropy hints are only sent if the embedded document is same-origin with
its embedder ([Example 1](#example-1)). The iframe's `allow` attribute is used to
name specific hints which should be sent to the embedded document
([Example 2](#example-2)).

If an embedded document is same-origin with its embedder, then Permissions
Policy will delegate all available hints by default. In that case, the `allow`
attribute can still be useful, both for restricting hints which would otherwise
be sent ([Example 3](#example-3)), and also for controlling hints when the iframe
is navigated away from its initial origin ([Example 4](#example-4)).

The `Permissions-Policy` header is also considered when delegating hints to
embedded documents. If a hint is named in a document's `Permissions-Policy`
header, then the corresponding allowlist is also checked, and the embedded
document's origin must *also* be included in that list in order for it to be
sent hints ([Example 5](#example-5)).

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
with the document ([Example 6](#example-6)).

By using the `Permissions-Policy` header, it is possible to name the origins for
which subresrouces should (or by omission, should not) receive hints
([Example 7](#example-7)).

Note that any hints which were not sent to the document in the first place
*cannot* be sent with any subresource requests, regardless of origin.

## Examples

### Example 1: Default behaviour of delegation to frames

Resource: https://example.com/

Response headers:
```http
Accept-CH: DPR
```

Markup:
```html
<iframe src="page2.html"></iframe>
<br>
<iframe src="https://external.example/"></iframe>
```

The request for the document in the first frame will be sent with the
low-entropy hints (UA, UA-Mobile and Save-Data) and the single received
high-entropy hint (DPR).

The request for the document in the second frame will only be sent with the
low-entropy hints.

### Example 2: Adding additional hints with markup

Resource: https://example.com/

Response headers:
```http
Accept-CH: DPR
```

Markup:
```html
<iframe src="https://external.example/" allow="ch-dpr;ch-ua-arch"></iframe>
```

The request for the document in the frame will be sent with the low-entropy
hints (UA, UA-Mobile and Save-Data) and the DPR high-entropy hint. The UA-Arch
hint cannot be sent, as it was not received by the parent document.

### Example 3: Restricting hints from same-origin frames

Resource: https://example.com/

Response headers:
```http
Accept-CH: DPR
```

Markup:
```html
<iframe src="page2.html" allow="ch-dpr 'none';ch-save-data 'none'"></iframe>
```

The request for the document in the frame will only be sent with two low-entropy
hints: UA and UA-Mobile. Both the low-entropy Save-Data hint and the
high-entropy DPR hint have been excluded by policy.

### Example 4: Restricting hints after navigation

Resource: https://example.com/

Response headers:
```http
Accept-CH: DPR
```

Markup:
```html
<iframe src="page2.html" allow="ch-save-data 'self'"></iframe>
```

Resource: https://example.com/page2.html

Markup:
```html
<a href="https://external.example/">External link</a>
```

The initial request for the document in the frame (`page2,html`) will be sent
with the low-entropy hints, as well as DPR. However, if the frame is navigated
away from the `https://example.com` origin, requests for other documents will
only be sent with the UA and UA-Mobile hints. The Save-Data hint will be
excluded because of the policy in the `allow` attribute, and the DPR hint will
be excluded because it is a high-entropy hint, and is not sent to a third-party
origin unless specifically delegated.

### Example 5: Restricting delegation with response headers

Resource: https://example.com/

Response Headers:
```http
Accept-CH: DPR
Permissions-Policy: ch-dpr=(self "https://external.example")
```

Markup:
```html
<iframe src="https://external.example/" allow="ch-dpr"></iframe>
<br>
<iframe src="https://another.example/" allow="ch-dpr"></iframe>
```

In this example, a `Permissions-Policy` response header has been used to set the
list of origins which can be sent the DPR hint.

The request for the document in the first frame will be sent with the
low-entropy hints and the DPR high-entropy hint, as it is present in the header
allowlist.

The request for the document in the second frame will only be sent with the
low-entropy hints. The DPR hint cannot be sent to that origin, as it was not
present in the header allowlist.

### Example 6: Default behaviour of hints for subresources

Resource: https://example.com/

Response headers:
```http
Accept-CH: DPR
```

Markup:
```html
<img src="banner.png">
<br>
<img src="https://external.example/photo.jpg">
```

The request for the first image will be sent with the
low-entropy hints (UA, UA-Mobile and Save-Data) and the single received
high-entropy hint (DPR).

The request for the second image will only be sent with the low-entropy hints.

### Example 7: Adding additional hints with response headers

Resource: https://example.com/

Response headers:
```http
Accept-CH: DPR
Permissions-Policy: ch-dpr=(self "https://external.example")
```
Markup:
```html
<img src="https://external.example/photo.jpg">
<br>
<img src="https://another.example/photo2.jpg">
```

In this example, a `Permissions-Policy` response header has been used to set the
list of origins which can be sent the DPR hint.

The request for the first image will be sent with the low-entropy hints and the
DPR high-entropy hint, as it is present in the header allowlist.

The request for the second image will only be sent with the low-entropy hints.
The DPR hint cannot be sent to that origin, either in a subresource request, as
shownhere, or in a subframe, as in the example above, as it was not present in
the header allowlist.
