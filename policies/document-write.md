# Document Stream Insertion Policy (Dynamic Mark-up)

## Objective
The API around document stream modification ([dynamic mark-up insertion](https://www.w3.org/TR/2011/WD-html5-author-20110705/apis-in-html-documents.html#dynamic-markup-insertion)), i.e., `document.write`, `document.writeln`, `document.open` and `document.close` 
are anti-pattern, parser-blocking JavaScript API. The objective of the proposed feature is to limit the usage of this API in websites.

## Solution

Introduce a new feature policy, namely, `document-write` to control the access to the mentioned API. When the feature is disabled for a specific origin in a frame, any usage of such API will be ignored and might
lead to a DOMException<sup>[1](#notes)</sup>.

## Usage
The feature can be set through the HTTP headers in the response. For instance

```
Feature policy: document-write 'none'
```

which would disable the feature for all same and cross origin content. The feature can also be set for a given `<iframe>`
by modifying the `allow` attribute. For instance,

```
<iframe src="https://example.com" allow="document-write https://www.google.com"></iframe>
```
would limit the usage of stream insertion API to only "www.google.com" origins using HTTPS protocol.

## Open Problems

The main open problem with this feature is cross-site isolation breakage. The feature provides an embedder website with the
power to arbitrarily turn off usage of some javascript APIs in an embedded site. If the embedded site relies on loading
important security related contents through the disabled API<sup>[2](#notes)</sup>, then the security of the embedded site
might become compromised. Therefore, to avoid exposing sites which

  * allow being embedded in other websites,
  * rely on `document.write` for adding important scripts,

to such attacks, the behavior of the feature for same-origin vs cross-origin might be different. The safest approach would be
to either allow usage of such API when the content is cross-origin, or, disallow it by unloading the frame. This would remove
the security concerns related to cross-site isolation.

A more forgiving approach would only unload the frame if
  * The frame is cross-origin,
  * The site does `document-write` feature mentioned in its header.

In other words, if a site is familiar with the feature then it is reasonable to assume that they have considered the
consequences of `document-write`.

#### Notes

1: The _most_ correct behavior is not known yet. For now, Chrome's implementation behind the flag simply throws exception
on API usage (for both same and cross origin). But this is not the final implementation.

2: An embedded website might rely on important `<script>` added to the document using `document.write`. It should be noted
that in general, a call to `document.write` for this purpose might not necessarily suceed (e.g., block fetching resource on
slow connections -- [WICG/interventions#17](https://github.com/WICG/interventions/issues/17)). However, through feature policy, embedder website has access to a switch to arbitrarily turn the feature off; hence the security concerns.
