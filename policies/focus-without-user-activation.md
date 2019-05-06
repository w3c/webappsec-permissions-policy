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
[problematic](https://github.com/w3c/webappsec-feature-policy/issues/273) since it provides bad
embedded content with a tool to steal input focus from the top-level. The proposed feature provides
a means for developers to block the use of automatic focus in nested contents.

Proposed Solution
------------
The proposed feature policy can be used to limit the use of automatic focus. Essentially, when the
policy is disabled in a document, scripted and automatic focus will only work if the focus has been
initialized through user activation. This essentially means that `autofocus` will be disabled (
unless a new element is inserted, with `autofocus`, as a result of user gesture). The scripted focus
will also only work if it has started with user gesture.

Details on "disabling focus"
------------
All automated focus eventually call into the [focus update steps](https://html.spec.whatwg.org/multipage/interaction.html#focus-update-steps) algorithm. When the policy
is disabled, this algorithm should not run.

In a nutshell:
  * Around step 4 of the [spec](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#attr-fe-autofocus for `autofocus` the algorithm should return if the policy `focus-without-user-activation` is disabled and the algorithm is not
  [triggered by user activation](https://html.spec.whatwg.org/multipage/interaction.html#triggered-by-user-activation).
  * Before starting [steps](https://html.spec.whatwg.org/multipage/interaction.html#dom-window-focus) for `element.focus(options)` the same verification for the policy and user activation should be performed.
  * Aroudn step 2 of the the [spec](https://html.spec.whatwg.org/multipage/interaction.html#dom-window-focus) for `window.focus(options)` the same enforcement should be made (using the browsing context of the `window` itself to obtaint he feature policy state.

Using the Feature
-------------
This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature-Policy: focus-without-user-activation 'none'
```
would cause the use of automatic focus in the page (and nested contexts) to fail unless it 
has been triggered by user activation.

To disable the feature for a specific `<iframe>`, the `allow` attribute can be used:
```HTTP
<iframe src="..." allow="focus-without-user-activation 'self'></iframe>
```
which would block use of focus (without activation) for the document inside the `<iframe>`
unless it is a same-origin document.

The Extra Mile
-----------
Automatic focus, in general, poses security concerns. It might be a good idea to disable this policy
in all sandbox-ed frames (treat the policy as a sandbox flag).
