loading-frame-default-eager Policy
===========

The `loading-frame-default-eager` policy-controlled feature can be used for a main frame or a nested
`<iframe>` to overwrite the default or assigned value of the newly
introduced `loading` [attribute](https://github.com/whatwg/html/pull/3752) for `<iframe>` and `<img>`.

What does that mean?
------------
With the `loading-frame-default-eager` attribute, developers could prioritize the loading of different inline frames on a web page. This however could become a cumbersome process and not quite scalable for larger
web sites specially given that applying the attribute is origin-agnostic. The proposed policy aims to resolve
this issue but changing a browser's default decision for `loading` behavior.

Proposed Solution
------------
The `loading` attribute can take one of the three values:
  * **`eager`** indicating that the resource should load eagerly (i.e., load even when below the fold).
  * **`auto`** the browser makes the call for the loading behavior; it probably defaults to `eager`.
  * **`lazy`**: the resource loads lazily.

The proposed `loading-frame-default-eager` policy will affect the `auto` attribute value in that when disabled inside a document, all the `<iframe>`'s which do not explicitly set the `loading` attribute to `eager` will most probably load lazily. This is equivalent to overriding the `loading` attribute of `auto` with `lazy`.
  
This feature could be enforced either in the HTTP header or by using the `allow` attribute of an inline frame.

Using the Feature
-------------

This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature-Policy: loading-frame-default-eager 'self' https://example.com
```
would defer loading  all `<iframe>`s from origins other than `self` and `https://example.com` that do not explicitly set `loading="eager"`  to when they are (almost) visible on the page. 

Similarly, the feature could be set through the `allow` attribute of an inline frame:
```HTML
<iframe src="https://example.com" loading="auto" allow="loading-frame-default-eager 'none'"></iframe>
```
which regards all the `<iframe>`s with `loading="auto"` or `<iframe>`s that do not set `loading` attribute (hence default to `auto`) as lazily loaded frames. Note that the frame itself is not affected by the policy and possibly loads eagerly.

The Extra Mile
-----------
In general the feature could allow an expanded set of enforcement policies with the use of [parametric features](https://github.com/WICG/feature-policy/issues/163). Under a geralized `loading-frame` policy, the following potential values could be supported (in the order of permissiveness):
  * `default`: the policy does not affect the behavior of the `loading` attribute,
  * `default-eager-off`: all the `loading="auto"` attributes (and those not set for a `<iframe>`) are regarded as `lazy`,
  * `eager-off`: all the `loading="eager"` and `loading="auto"` (and unset `<iframe>`s) are interpretted as `loading="lazy"`.
 
