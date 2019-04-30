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
To avoid unnecessary breakage of existing contents, disabling the focus should still let parts of
the [focus update steps](https://html.spec.whatwg.org/multipage/interaction.html#focus-update-steps)
run. In a nutshell:
  * The `activeElement` of the blocked document should be updated. All the focus related events
  should also fire.
  * Nothing should happen to the old focus chain (no element losing focus or receiving a `blur`
  event).
  * The [focusable area](https://html.spec.whatwg.org/multipage/interaction.html#focusable-area)
  should not change.


Using the Feature
-------------
This feature can be introduced with the HTTP headers. For instance,
```HTTP
Feature-Policy: focus-without-user-activation 'none'
```
would cause all all automatic focus in the page (and neste contexts) to fail unless it has been
triggered by user activation.

To disable the feature for a specific `<iframe>`, the `allow` attribute can be used:
```HTTP
Feature-Policy: focus-without-user-activation 'self'
```
which would block use of focus (without activation) for all origins except 'self'.

The Extra Mile
-----------
Automatic focus, in general, poses security concerns. It might be a good idea to disable this policy
in all sandbox-ed frames (treat the policy as a sandbox flag).
