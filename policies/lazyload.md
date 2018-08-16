Lazyload Policy
===========

The `lazyload` policy-controlled feature can be used for a main frame or a nested
`<iframe>` or `<img>` to overwrite the default or assigned value of the newly
introduced `lazyload` [attribute](https://github.com/whatwg/html/pull/3752) for `<iframe>` and `<img>`.

What does that mean?
------------
With the `lazyload` attribute, developers could prioritize the loading of different inline frames and
images on a web page. This however could become a cumbersome process and not quite scalable for larger
web sites specially given that applying the attribute is origin-agnostic.

Proposed Solution
------------

A new policy-control feautre for lazyoading alter lazyload behavior for a browsing context and its nested contexts. The feature will modify the behavior of user agent towards the `lazyload` attributed value for nested resources. Essentially
when the feature is disabled for an origin, then no resource inside the origin can escape lazyloading by setting
`lazyload="off"`. Specifically, if for a resource the `lazyload` attribute is set to:

  * **`on`** ten the browser should load the resource lazily.
  * **`off`** then the browser ignores the attribute value and assumes **`auto`**.
  * **`auto`**: there is no change in browser behavior.
  
This feature could be enforced either in the HTTP header or by using the `allow` attribute of an inline frame.

Using the Feature
-------------

This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature Policy: lazyload 'src' https://example.com
```
would not allow synchronous loading for any `<iframe>` or `<img>` (that is not yet in the viewport) from origins other than`'self'` or `https://example.com`.

Similarly, the feature could be set through the `allow` attribute of an inline frame:
```HTML
<iframe src="https://example.com" lazyload="off" allow="lazyload 'none'"></iframe>
```
which disregards `lazyload='off'` for all the origins including the `<iframe>`'s origin itself.

The Extra Mile
-----------
In general the feature could allow an expanded set of enforcement policies with the use of [parametric features](https://github.com/WICG/feature-policy/issues/163). For instance, the feature could be used to enforce `lazyload` for certain origins (by enforcing `lazyload='on'` on all resources) and prefer synchronous loading for all local resources (i.e., suggest a default browser behavior of `lazyload='off'`):
```
Feature Policy: 'self'(off) https://example.com(enforce-on)
```
In the example above an image in self such as ``` <img src="./foo.jpg"/>``` (which is same-origin) should be loaded synchronously, but, `<iframe src="https://example.com/page.html" lazyload="off"></iframe>` is loaded lazily due to policy enforcement.
