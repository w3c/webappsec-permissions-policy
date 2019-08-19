loading-frame-default-eager Policy
===========

The `loading-frame-default-eager` policy-controlled feature can be used for a main frame or a nested
`<iframe>` to override the default behavior of the newly
introduced `loading` [attribute](https://github.com/whatwg/html/pull/3752).

What does that mean?
------------
With the `loading-frame-default-eager` policy, developers could prioritize the loading of different inline frames on a web page. This however could become a cumbersome process and not quite scalable for larger
web sites; specially given that applying the attribute is origin-agnostic. The proposed policy aims to resolve
this issue by changing a browser's default decision for `loading` behavior.

Proposed Solution
------------
The `loading` attribute can take one of the three values:
  * **`eager`** indicating that the resource should load eagerly (i.e., load even when below the fold).
  * **`auto`** the browser makes the call for the loading behavior; it probably defaults to `eager`.
  * **`lazy`**: the resource loads lazily.

The proposed `loading-frame-default-eager` policy will affect the `auto` attribute value in that when disabled, `loading="auto"` (or unset) will be treated as `lazy`, which means that frames with unspecified `loading` attribute will be lazily loaded.
  
This feature could be enforced either in the HTTP header or in the `allow` attribute of an inline frame.

Using the Feature
-------------

This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature-Policy: loading-frame-default-eager 'none'
```
would cause all the nested `<iframe>`'s and the corresponding nested and auxiliary browsing contexts to load lazily, unless they have specifically set `loading="eager"`. For example, if the document has
```HTML
<iframe id="frame"></iframe>
<iframe id="fast" loading="eager"></iframe>
```
then the `<iframe>` with `id="frame"` loads lazily but the `<iframe>` with `id="fast"` would load normally (eagerly).

Similarly, to allow certain origins,
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
In general the feature could allow an expanded set of enforcement policies with the use of [parametric features](https://github.com/WICG/feature-policy/issues/163). Under a generalized `loading-frame` policy, the following potential values could be supported (in the order of permissiveness):
  * `default`: the policy does not affect the behavior of the `loading` attribute,
  * `default-eager-off`: all the `loading="auto"` attributes (and those not set for a `<iframe>`) are regarded as `lazy`,
  * `eager-off`: all the `loading="eager"` and `loading="auto"` (and unset `<iframe>`s) are interpretted as `loading="lazy"`.
 
