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
  * Around step 2 of the the [spec](https://html.spec.whatwg.org/multipage/interaction.html#dom-window-focus) for `window.focus()` the same enforcement should be made (using the browsing context of the `window` itself to obtain the feature policy state.

Pseudo-algorithm for how the policy would integrate with focus:

```
algorithm is_allowed_to_set_focus(focus_setter_frame, currently_focused_frame):
  if focus_setter_frame has the policy allowed:
    return true

  if currently_focused_frame is an [inclusive descendant](https://html.spec.whatwg.org/#inclusive-descendant-navigables) frame of focus_setter_frame:
    return true

  return false
```

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

Alternative Solutions Considered
-----------
This section lists other possible solutions that were considered during the development of the proposal outlined in this explainer.

1. **HTMLIFrameElement boolean attribute**: A new `disallowprogrammaticfocus` boolean attribute on the [HTMLIFrameElement](https://html.spec.whatwg.org/multipage/iframe-embed-object.html#htmliframeelement) was explored. When set, this attribute would prevent all nested iframes from taking input focus through script. An example implementation would look as follows:

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

   In this approach, the iframe would be unable to steal focus unless the user explicitly switches focus to that element.

   This approach was abandoned because it represents a heavier-weight solution compared to a permissions policy. Additionally, it would be easier for sites to adopt a new permissions policy if they are already using permissions policies to control other behaviors, rather than introducing a new HTML attribute.

2. **Alternative policy naming**: An alternative policy name was considered: `disallow-programmatic-focus`. However, to maintain consistency with existing permissions policies, it is more appropriate to use positive polarity (where denying the policy disables the functionality) for backwards compatibility.

3. **Sandbox flag approach**: The possibility of implementing this control as a [sandbox](https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/sandbox) flag was analyzed instead of a permissions policy.

   Adding this functionality to the sandbox would be potentially breaking, as it would immediately affect every sandboxed frame and require all sites to update their code if they needed to restore the functionality. In contrast, implementing this as a permissions policy is non-breaking: with a default allowlist of `'self'`, it provides an opt-in control mechanism that is enabled by default everywhere but can be selectively disabled when needed.

Appendix
-----------

These are some example cases of how focus setting would now work with this new policy in the pseudo-algorithm described above:

| Case | Policy Enabled on `focus_setter_frame` | `focus_setter_frame` | `currently_focused_frame` | Allowed to Set Focus? | Reason |
|------|----------------------------------------|------------------------|----------------------------|------------------------|--------|
| 1    | No                                  | Parent                 | Child                      | Yes                 | Parent-child relationship is allowed by default. |
| 2    | No                                  | Child                  | Parent                     | No                  | No policy and not a permitted direction. |
| 3    | No                                  | Grandparent            | Grandchild                 | Yes                 | Ancestor allowed to set focus when a descendant has it. |
| 4    | No                                  | Grandchild             | Grandparent                | No                  | No policy and not a direct relationship. |
| 5    | No                                  | Same frame             | Same frame                 | Yes                 | A frame is always allowed to set focus on (maybe another element of) itself if it already has focus. |
| 6    | Yes                                 | Parent                 | Child                      | Yes                 | Policy allows it explicitly. |
| 7    | Yes                                 | Child                  | Parent                     | Yes                 | Policy allows it explicitly. |
| 8    | Yes                                 | Grandparent            | Grandchild                 | Yes                 | Policy allows it explicitly. |
| 9    | Yes                                 | Grandchild             | Grandparent                | Yes                 | Policy allows it explicitly. |
| 10   | Yes                                 | Same frame             | Same frame                 | Yes                 | Policy allows it explicitly. |
