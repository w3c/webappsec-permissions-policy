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

A new policy-control feautre for lazyoading alter lazyload behavior for a browsing context and its nested contexts, either by
  * Changing the *default* decision of the user agent for `<iframe>` and `<img>` whose `lazyload` attribute is unset, i.e.,
    set to **`auto`**, or,
  * Enforcing the lazyload policy for all `<iframe>` and `<img>`.
  
This feature could be enforced either in the HTTP header or by using the `allow` attribute of an inline frame.
  
The achieve the described behavior, the proposed policy would need to operate in three different modes:

  * **`auto`**: which is the default feature value and when used the decision on lazyloading is deferred to the
  browser.
  * **`off`**: which sets the default user agent behavior to *not* lazyload resources unless
    * the resource has the `lazyload` attribute set to **`on`**, or,
    * the resource has the `lazyload` attribute set to **`auto`** and the default user agent behavior is to
    enforce lazyloading.
  * **`force`**: which will force lazyloading for all resources in the browsing context and the nested contexts. Note
  that this takes precendence over any set `lazyload` attribute value for `<iframe>` and `<img>` inside the browsing
  contexts.

To accomodate all the three cases above, the feature has to be *[parameterized](https://github.com/WICG/feature-policy/issues/163)*.

Using the Feature
-------------

This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature Policy: lazyload 'src'(off) https://example.com(force)
```
would avoid lazyloading any `<iframe>` or `<img>` from origin `'self'` (unless the element's `lazyload` attribute is **`on`**),
but would enforce lazyloading to all the resources from origin `https://example.com` ignoring the assigned `lazyload` attribute
to the `<iframe>` and `<img>` in the web pages form that oigin or any sites nested inside.

Similarly, the feature could be set through the `allow` attribute of an inline frame:
```HTML
<iframe src="https://example.com" lazyload="on" allow="lazyload *(force)"></iframe>
```
which enforces lazyloading on all origin. Note that this would effectively overwrite the current value of the
`lazyload` attribute set for this inline frame.
