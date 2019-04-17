loading-image-default-eager Policy
===========

The `loading-image-default-eager` policy-controlled feature (the image loading policy counterpart of
`loading-frame-default-eager`) can be used for a main frame or a nested `<iframe>` to override the default behavior of the
newly introduced `loading` [attribute](https://github.com/whatwg/html/pull/3752) for images.

What does that mean?
------------
With the `loading-image-default-eager` attribute, developers could prioritize the loading of `<img>`'s on a web page.
This however could become a cumbersome process and not quite scalable for larger
web sites specially given that applying the attribute is origin-agnostic. The proposed policy aims to resolve
this issue but changing a browser's default decision for `loading` behavior.

Proposed Solution
------------
The `loading` attribute can take one of the three values:
  * **`eager`** indicating that the resource should load eagerly (i.e., load even when below the fold).
  * **`auto`** the browser makes the call for the loading behavior; it probably defaults to `eager`.
  * **`lazy`**: the resource loads lazily.

The proposed `loading-image-default-eager` policy will affect the `auto` attribute value in that when disabled,
`loading="auto"` (or unset) will be treated as `lazy`, which means that images which don't set the attribute to `eager`
will (usually) be lazily loaded.
  
This feature could be enforced either in the HTTP header or by using the `allow` attribute of an inline frame.

Using the Feature
-------------

This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature-Policy: loading-image-default-eager 'none'
```
would cause all the `<img>`s on the page, in the nested `<iframe>`'s, and in the auxiliary browsing contexts (except
those which explicitly set `loading="eager"`) to load lazily. For example, if the document has two below-the-fold images
```HTML
<!-- the following images are not initially visible -->
<img src="foo.jpeg">
<img loading="eager" src="bar.jpeg">
```
then the `foo.jpeg` image will load lazily but `bar.jpeg` loads immediately with the page since it is explicitly marked with
eager loading.

Similarly, to allow the feature for certain origins,
```HTTP
Feature-Policy: loading-image-default-eager 'self' https://example.com
```
would defer loading all `<img>`s from origins other than `self` and `https://example.com` that do not explicitly set
`loading="eager"`  to when they are (almost) visible on the page. 

Similarly, the feature could be set through the `allow` attribute of an inline frame:
```HTML
<iframe src="https://example.com" loading="auto" allow="loading-image-default-eager 'none'"></iframe>
```
which regards all the `<img>`s with `loading="auto"` or `<img>`s that do not set `loading` attribute (hence default to `auto`)
as lazily loaded images.

The Extra Mile
-----------
In general the feature could allow an expanded set of enforcement policies with the use of
[parametric features](https://github.com/WICG/feature-policy/issues/163). Under a geralized `loading-image` policy,
the following potential values could be supported (in the order of permissiveness):
  * `default`: the policy does not affect the behavior of the `loading` attribute,
  * `default-eager-off`: all the `loading="auto"` attributes (and those not set for a `<img>`) are regarded as `lazy`,
  * `eager-off`: all the `loading="eager"` and `loading="auto"` (and unset `<img>`s) are interpretted as `loading="lazy"` (
  _could lead to a violation report_ if the `loading` attribute for an `<img>` is set to `eager`).
 
