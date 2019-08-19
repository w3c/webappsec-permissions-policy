`decoding-image-default-sync` Policy
===========

The `decoding-image-default-sync` policy-controlled feature can be used for a main frame or a nested `<iframe>` to override the default behavior of the [`decoding` attribute](https://html.spec.whatwg.org/multipage/embedded-content.html#attr-img-decoding) for images.

What does that mean?
------------
With the `decoding-image-default-sync` policy, developers could prioritize the decoding of `<img>`s on a web page.
Developers may use the `decoding` attribute to specify the decoding method for an image, this however could become a cumbersome process and not quite scalable for larger web sites specially given that applying the attribute is origin-agnostic. The proposed policy aims to resolve this issue by changing a browser's default decision for `decoding` behavior.

Proposed Solution
------------
The `decoding` attribute can take one of the three values:
  * **`sync`** indicating that the image should decode synchronously.
  * **`auto`** the browser makes the call for the decoding behavior; it probably defaults to `sync`.
  * **`async`**: the image should decode asynchronously.

The proposed `decoding-image-default-sync` policy will affect the `auto` attribute value in that when disabled,
`decoding="auto"` (or unset) will be treated as `async`; which means that images that do not explicitly set their `decoding` attribute to `sync` will be asynchronously decoded.
  
This feature could be enforced in the`Feature-Policy` HTTP header or the `allow` attribute of an inline frame.

Using the Feature
-------------

This feature can be introduced with the `Feature-Policy` HTTP header. For instance,
```HTTP
Feature-Policy: decoding-image-default-sync 'none'
```
would cause all the `<img>`s on the page, in the nested `<iframe>`'s, and in the auxiliary browsing contexts (except
those which explicitly set `decoding="sync"`) to decode asynchronously. For example, if the document has two images
```HTML
<img src="foo.jpeg">
<img decoding="sync" src="bar.jpeg">
```
then the `foo.jpeg` image will be decoded asynchronously but `bar.jpeg` decoded synchronously since it is explicitly marked `decoding="sync"`.

Similarly, to allow the feature for certain origins,
```HTTP
Feature-Policy: decoding-image-default-sync 'self' https://example.com
```
would imply asynchronous decoding for all `<img>`s from origins other than `self` and `https://example.com` that do not explicitly set
`decoding="sync"`.

Similarly, the feature could be set through the `allow` attribute of an inline frame:
```HTML
<iframe src="https://example.com" allow="decoding-image-default-sync 'none'"></iframe>
```
which regards all the `<img>`s with `decoding="auto"` or `<img>`s that do not set the `decoding` attribute (hence default to `auto`)
to be asynchronously decoded.

The Extra Mile
-----------
In general the feature could allow an expanded set of enforcement policies with the use of
[parametric features](https://github.com/WICG/feature-policy/issues/163). Under a generalized `decoding-image` policy,
the following potential values could be supported (in the order of permissiveness):
  * `default`: the policy does not affect the behavior of the `decoding` attribute,
  * `default-sync-off`: all the `decoding="auto"` attributes (and those not set for a `<img>`) are regarded as `async`,
  * `sync-off`: all the `decoding="sync"` and `decoding="auto"` (and unset `<img>`s) are interpretted as `decoding="async"` (
  _could lead to a violation report_ if the `decoding` attribute for an `<img>` is set to `sync`).
