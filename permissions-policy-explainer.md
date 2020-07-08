# Permissions Policy Explainer

Permissions policy is a web platform API which gives a website the ability to
allow or block the use of browser features in its own frame or in iframes that
it embeds. It operates on the principle that top-level documents should
generally have access to the web's powerful features (often at the discretion of
the user, who needs to grant permission,) but that embedded content should not
have such access automatically. A document which embeds another document should
be able to declare which features it trusts that embedded content to use.

Examples of features that can be controlled by permissions policy include:
* Battery status
* Client Hints
* Encrypted-media decoding
* Fullscreen
* Geolocation
* Picture-in-picture
* Sensors: Accelerometer, Ambient Light Sensor, Gyroscope, Magnetometer
* User media: Camera, Microphone
* Video Autoplay
* Web Payment Request
* WebMIDI
* WebUSB
* WebXR


## Wait, isn't this Feature Policy?

Yes, this API was previously known as Feature Policy, and was shipped as such in
Google Chrome since 2016.

There have been several changes to the API since it shipped as Feature Policy.
If you're already familiar with Feature Policy, feel free to skip to the
["Big Changes"](#big-changes) section below.


## A bit of history

The ideas for permissions policy, and feature policy before it, came out of
several needs that arose in the web platform space:

* It became apparent that some features are better off disabled by default in 
iframes, especially those hosting content from a different origin than their 
containing page. However, there may be legitimate cases where such behavior is 
desirable, and web applications should be able to (explicitly) delegate 
permission to such frames. Different features have historically handled this in 
very different ways: some features have had dedicated iframe attributes for 
allowing their use; others have been declared usable only by the top-level 
document, or have been usable everywhere except in sandboxed iframes.

* Similarly, folks working on permissions have seen a need to disable sensitive 
features like geolocation by default in iframes, to reduce the chance of users 
being confused or tricked into giving embedded websites access. See FP + 
Permissions for more details on the relationship between this document and 
permissions.

* Ideas for mitigations against XSS attacks were also being discussed. For 
example, if a website knows it never uses the Bluetooth API, it can mitigate 
against XSS attacks by telling the browser that it should never expose the 
Bluetooth API to its frame and/or its descendants - i.e. developers want to 
draw a security perimeter for their applications.

* From a performance perspective, there is demand from site owners to specify a 
contract about use, or lack of thereof, of certain features both within their 
own context and for embedded contexts, which may affect performance and UX of 
the embedder - e.g. disable use of synchronous scripts and XHRs, etc. This 
contact of use may also be used, for example, to enable certain types of "fast 
path" optimizations in the browser, or to assert a promise about conformance 
with some requirements set by other embedders - e.g. various social networks, 
search engines, and so on.

* There is a desire for a framework to expose experimental features (Origin 
Trials) in the browser, but only to specific/registered origins, and for 
limited duration and subject to global usage caps.

Feature policy grew out of the ideas and aims to address the above needs 
via a single and unified interface. 

Since then, feature policy has split into two related APIs to cover the widely
different use cases: Permissions policy to handle the control of powerful
features and permissions, even in the presence of XSS; and [Document policy](https://github.com/w3c/webappsec-feature-policy/blob/master/document-policy-explainer.md),
to handle performance optimizations and other kinds of configurable APIs.

## How is a Policy Specified?

Permissions policy can be thought of conceptually as a way to control delegation
of powerful features to subframes. It operates on allowed lists of origins for
each feature, where a "feature" is a well-defined token that maps to and
controls some web platform API - e.g. “geolocation” is a feature name for the 
Geolocation API, and a policy of “`geolocation https://foo.com https://bar.com`”
indicates that geolocation is enabled for foo.com and bar.com.

Any frames a website embeds that aren’t of a listed origin will have that 
feature disabled - e.g. with above policy a frame containing https://baz.com/ 
would have the Geolocation API disabled. If the website's own origin doesn’t 
appear jin the allowlist, the feature will be disabled for itself too. And, 
finally, if no policy is specified by a website for a particular feature, then 
a default allowlist will be used for that feature. 

The primary way of delegating access to powerful features is through the `allow`
attribute of the iframe element. By default, powerful features are allow in the
top-level document, and its same-origin frames, but blocked in cross-origin
frames. The `allow` attribute can be used to set this policy on a frame-by-frame
basis:

```html
<iframe src="https://foo.com/" allow="geolocation; camera"></iframe>
```

Similar to sandbox flags, this attribute only takes effect at the point an 
iframe is loaded. If it is changed, the iframe must be reloaded to enforce the 
new policy.

By default, features specified in the `allow` attribute are allowed only as long
as the origin of the document in the frame matches the iframe's `src` attribute,
and will not be granted if it navigates away from that origin, but that can be
changed by appending an allowed list of origins to the feature:

```html
<iframe src="https://foo.com/" allow="geolocation 'src' https://bar.com'; camera *"></iframe>
```
Secondly, the `Permissions-Policy` HTTP response header can be used to restrict
the list of origins which could potentially be granted access through the
`allow` attribute. By default, for most features this list is `*`, which means
that an iframe element could name any origin in its `allow` attribute, and have
access granted to a document in that frame. Restricting this list through the
header means that even if an iframe specifies an origin, if the origin is not
allowed by the header, the feature will not be given to the framed document.

As an example, a policy may be specified in the HTTP “Feature-Policy” header
like this (which is formatted for ease of reading):

```http
Permissions-Policy:
    geolocation=(self "https://foo.com"),
    camera=(),
    fullscreen=*
```

In this example, “`self`” will resolve to the origin that specifies the policy; 
“`*`” will resolve to the set of all origins; and the empty list of origins 
indicates that the feature should be disabled for all frames.

This policy indicates that geolocation permission can only be granted to
same-origin frames and to frames hosting documents from foo.com. Camera access
is disabled for *all* documents, including this one, and full screen mode can
potentially be granted to any frame (although it is not granted by default; the
`allow` attribute must still be used on individual frames.)

## How are Features Disabled?

The way that features get disabled varies from feature-to-feature. 
Permission-like features, such as geolocation, already fail sensibly and return 
error values when the permission to use it is missing. When such a feature is 
disabled by Feature Policy, it would be equivalent to a denied permission and 
would exercise a similar code path (perhaps returning a different error code).  

In other cases, the feature may fail silently, be removed from the global 
object altogether or fail in some other way that makes the most sense for that 
API - i.e. we’ll consider and choose the best strategy on a case by case basis. 

For example disabling synchronous `<script>` tags on a page, would cause those 
parser-blocking script resources not to be loaded. Note that in these types of 
cases, the control flow of JavaScript on the page may change due to features 
being removed or disabled. As such, it is possible that some attackers could 
potentially exploit these changes in control flow to exploit the page. In such 
cases, if a violation of feature policy is detected, the browser may unload the 
page to mitigate against such attacks. 

## Permissions Policy and the Permissions API

One of the goals of feature policy is to give control to embedders over how 
permissions are enabled/disabled in iframes. There are open questions around 
the relationship between Feature Policy, Permission Delegation and the 
Permissions API which need to be worked out. A separate document Feature Policy 
and Permissions describes some of these questions in more detail.

## Permissions Policy and the Reporting API

Feature policy integrates with the Reporting API, so that you can get reports 
from users when a policy is violated in their browser, or respond to violations 
in JavaScript. See the separate explainer, Feature Policy Reporting, for 
details.

## Inspecting the Current Policy

Permissions policy provides a JavaScript interface to query the policy which is 
active in the current document. You can use it to tell whether specific 
features are enabled or not, or whether they would be enabled by iframes 
(depending on the content loaded into that iframe). See Policy Introspection 
from Scripts in the specification for more details.

## Examples

The first set of examples deals with permission features. The `geolocation`
permission, which grants access to the user's physical location, is used as an
example, but any other permission should work in an analogous way.

### Example 1 - Using the default policy

In this scenario, example.com embeds an advertisement from ad.com. Being the
top-level document, example.com has the ability to request permission to access
the user's locatioin, but this ability is not granted to ad.com.

If ad.com attempts to access the user's location, it will receive a "permission
denied" error, exactly as if the user denied permission to the site.

example.com:
```html
<iframe src="https://ad.com/"></iframe>
```

### Example 2 - Enable geolocation in a cross-origin frame

In this scenario, example.com embeds two frames, one hosting an ad from ad.com,
and the other hosting a navigation widget from maps.example.com. example.com
wants to allow maps.example.com to use the geolocation feature, but still does
not want to grant that access to ad.com.

example.com can use the iframe `allow` attribute to delegate access to the frame
containing the navigation widget, which will allow that document to request the
user's location, The ad.com frame is still unable to even make the request.

example.com:
```html
<iframe src="https://game.com/" allow="geolocation"></iframe>
<iframe src="https://ad.com/"></iframe>
```

Note that `allow="geolocation"` here is actually shorthand for
`allow="geolocation 'src'"`, where `'src'` is a special token which will expand
into the origin which the iframe tag names, usually in its `src` attribute.
https://game.com, in this case.

### Example 3 - Cascading disable 

Here, example.com embeds an advertisement from bad-ad.com. It does not grant 
that frame access to geolocation, The ad then embeds a frame of its own, and 
attempts to grant that frame access. This will also be blocked by permissions 
policy, as a frame which is not allowed a specific feature cannot grant that 
feature to any of its subframes.

example.com:
```html
<iframe src="https://bad-ad.com/"></iframe>
```

bad-ad.com
```html
<iframe src="https://evil.com/" allow="geolocation"></iframe>
```


### Example 4 - Policy only directly affects child frame

In this example, a trusted subframe *is* able to delegate access to a feature to
one of its subframes. Example.com embeds a widget from game.com, granting it
geolocation access. Game.com then embeds another document from 
resources.game.com, and allows it access to geolocation as well. This succeeds, 
even though example.com didn’t explicitly allow it.  This may seem 
counter-intuitive but it accurately reflects the trust relationship that is 
expressed in the policy: example.com trusts game.com to use geolocation and so 
game.com must be trusted to responsibly delegate access further.

example.com 
```html
<iframe src="https://game.com/" allow="geolocation"></iframe>
```

game.com
```html
<iframe src="https://resources.game.com/" allow="geolocation"></iframe>
```

### Example 5 - Restrict delegation with an HTTP header

To tighten things down, example.com wants to ensure that it can only grant
location access to a small set of sites, even if someone manages to create an
iframe on example.com and can set its `allow` attribute.

It can do this with the `Permissions-Policy` header, which sets the origins that
can potentially be granted access to features;

example.com
```http
Permissions-Policy: geolocation=(self "https://game.com" "https://map.example.com")
```

```html
<iframe src="https://game.com/" allow="geolocation"></iframe>
<iframe src="https://evil.com/" allow="geolocation"></iframe>
```

Since the header has been set, the first iframe will be allowed to request the
user's location, while the second will be blocked.

Note that `self` here is a special token which will be expanded to the origin of
the document serving this header -- in this case, https://example.com.

### Example 6 - Disable a feature entirely with an HTTP header

In this scenario, example.com knows that it never uses geolocation, and wants 
to ensure that everything it embeds does not either, even if somehow an iframe 
with an allow attribute can be inserted into its documents that would otherwise 
grant that. The empty allowlist ensures that the feature is disabled in all 
contexts everywhere. 

example.com
```http
Permissions-Policy: geolocation=()
```

### Example 7 - Iframe navigations
 
The allow attribute can specify a list of origins as well. Any document which is
loaded into that frame from one of those origins can have access to the feature
delegated to it (as long as it's not blocked by the header, as in the examples
above). If the frame navigates to any other origin, the feature will be blocked.

In this scenario, example.com embeds game.com and ad.com. example.com specifies
with the `allow` attribute that geolocation is allowed for game.com and
new-game.com only. However the game.com iframe then navigates itself to
other-game.com. other-game.com will not have access since it’s not specified in
the policy. Subsequently the same iframe navigates to new-game.com which is
allowed access.


example.com:
```html
<iframe src="https://game.com/" allow="geolocation https://game.com https://new-game.com"></iframe>
<iframe src="https://ad.com/"></iframe>
```

## Appendix: Big changes since this was called Feature Policy {#big-changes}

Permissions Policy works largely exactly the way that feature policy did before
it. However, there are a number of cosmetic and logical differences:

### New header

The biggest visible change is that the `Feature-Policy` header is now spelled
`Permissions-Policy`, and its value is a [Structured Field Value](https://httpwg.org/http-extensions/draft-ietf-httpbis-header-structure.html).
(Technically, it's a structured Dictionary, whose names are the feature names,
and values are either items or inner lists, but see the spec for all of the
details there)

A policy which would previously have been expressed as

```http
Feature-Policy: fullscreen 'self' https://example.com https://another.example.com;
    geolocation *; camera 'none'
```

would now look like:

```http
Permissions-Policy: fullscreen=(self "https://example.com" "https://another.example.com"),
    geolocation=*, camera=()
```

 * `self` and `*` are tokens, and don't need to be quoted.
 * Origins are strings, and *do* need double quotes.
 * Allow lists are normally enclosed in parentheses, but those can be omitted
    if there is only a single element.
 * Decalarations are separated by `,` rather than `;`.

### Header and allow attribute combine differently

The second big change is that the header can now be used to restrict where the
document is allowed to delegate features to. Previously, if an origin was
specified in either the `Feature-Policy` header **OR** an iframe `allow`
attribute, then a feature would be granted to a document in that frame. Now, the
origin must be mentioned in both the `Permissions-Policy` header **AND** the
`allow` attribute.

To make this work with existing uses, where just the `allow` attribute is used,
without any header, the header's default implied value is generally `*`, and the
`allow` attribute's default value is `self` for permissions-style features.
