focus-without-user-activation Policy
===========

The `focus-without-user-activation` policy-controlled feature helps control the use of
automated focus in a main frame or `<iframe>`.

What does that mean?
------------
Automatic focus could happen through:
  * Use of `autofocus` attribute on a form control (e.g. `<input>`),
  * Use of scripted focus such as `element.focus()` and `window.focus()`.

Automatic focus is potentially
[problematic](https://github.com/w3c/webappsec-permissions-policy/issues/273) since it provides bad
embedded content with a tool to steal input focus from the top-level. The proposed feature provides
a means for developers to block the use of automatic focus in nested contents.

Proposed Solution
------------
The proposed permission policy can be used to limit the use of automatic focus. Essentially, when the
policy is disabled in a document, scripted and automatic focus will only work if the focus has been
initialized through user activation. This essentially means that `autofocus` will be disabled
(unless a new element is inserted, with `autofocus`, as a result of user gesture). The scripted
focus will also only work if it has started with user gesture.

Details on "disabling focus"
------------
All automated focus eventually call into the [focusing steps](https://html.spec.whatwg.org/multipage/interaction.html#focusing-steps) algorithm. When the policy
is disabled, this algorithm should not run.

In a nutshell:
  * Around step 4 of the [spec](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#attr-fe-autofocus) for `autofocus` the algorithm should return if the policy `focus-without-user-activation` is disabled and the algorithm is not
  [triggered by user activation](https://html.spec.whatwg.org/multipage/interaction.html#triggered-by-user-activation).
  * Before starting [steps](https://html.spec.whatwg.org/multipage/interaction.html#dom-window-focus) for `element.focus(options)` the same verification for the policy and user activation should be performed.
  * Around step 2 of the the [spec](https://html.spec.whatwg.org/multipage/interaction.html#dom-window-focus) for `window.focus()` the same enforcement should be made (using the browsing context of the `window` itself to obtain the permission policy state.

Using the Feature
-------------
This feature can be introduced with the HTTP headers. For instance,
```HTTP
Permission-Policy: focus-without-user-activation 'none'
```
would cause the use of automatic focus in the page (and nested contexts) to fail unless it 
has been triggered by user activation.

To disable the feature for a specific `<iframe>`, the `allow` attribute can be used:
```HTTP
<iframe src="..." allow="focus-without-user-activation 'self'"></iframe>
```
which would block use of focus (without activation) for the document inside the `<iframe>`
unless it is a same-origin document.

The Extra Mile
-----------
Automatic focus, in general, poses security concerns. It might be a good idea to disable this policy
in all sandbox-ed frames (treat the policy as a sandbox flag).

Alternative Solutions Considered
-----------
This section lists other possible solutions that came up during the development of the one proposed in this explainer.

1. A new `disallowprogrammaticfocus` boolean attribute on the [HTMLIFrameElement](https://html.spec.whatwg.org/multipage/iframe-embed-object.html#htmliframeelement) was explored. Whenever it is set, all the nested iframes can no longer take input focus through script. This would look as follows for example,

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>iframe steal focus prevention</title>
  </head>
  <body>
    <iframe src=""
            disallowprogrammaticfocus>
    </iframe>
  </body>
</html>
```

In this case, the iframe wouldn't be able to steal focus unless the user explicitly switches focus to that element.

This idea was abandoned because it's a heavier weight approach compared to a permission policy. Also, it could be easier for sites to adopt a new permission policy if they're already using them to control other things versus a new attribute.

2. An alternative policy name was considered at one point: "disallow-programmatic-focus". However, in order to match the style of existing permission policies, it's more convenient to have the polarity the other way around, so that denying the policy disables the functionality, for backwards compatibility.

3. Instead of a permission policy, it was analyzed whether having a sandbox flag could make more sense.
But adding it to sandbox is potentially breaking as it would immediately affect every sandboxed frame and all sites would need to update their code to avoid it if they needed control back. On the other hand, it isn't breaking when controllable through a permission policy, with a default allowlist of 'self' it would be an option which could be disabled but would be enabled by default everywhere.
