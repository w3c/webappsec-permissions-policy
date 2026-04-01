# `focus-without-user-activation` Permissions Policy

## Participate

- [Original Issue: w3c/webappsec-permissions-policy#273](https://github.com/w3c/webappsec-permissions-policy/issues/273)
- [GitHub Issues on WHATWG HTML](https://github.com/whatwg/html/issues?q=focus-without-user-activation)

## Table of Contents

- [Introduction](#introduction)
- [User-Facing Problem](#user-facing-problem)
- [Goals](#goals)
- [Non-goals](#non-goals)
- [Proposed Approach](#proposed-approach)
- [Alternatives Considered](#alternatives-considered)
- [Accessibility, Privacy, and Security Considerations](#accessibility-privacy-and-security-considerations)
- [Stakeholder Feedback / Opposition](#stakeholder-feedback--opposition)
- [Open Questions](#open-questions)
- [References](#references)
- [Appendix](#appendix)

## Introduction

Embedded third-party content (ads, widgets, iframes) can programmatically steal input focus from the top-level page without any user interaction. This causes keystrokes to be silently redirected, confuses users, and creates security and accessibility problems.

The `focus-without-user-activation` permissions policy gives embedders a declarative way to prevent this. When the policy is disabled for a frame, programmatic focus calls (`element.focus()`, `autofocus`, `window.focus()`) are blocked unless triggered by a user gesture. User-initiated focus (clicking, tabbing) is never affected. The policy can be set via an HTTP response header or the iframe `allow` attribute.

## User-Facing Problem

### Scenario 1: Ad steals focus from a news article

A user is reading a news article. An ad loaded in an iframe calls `element.focus()` on a hidden input, silently capturing the user's keystrokes:

```html
<!-- Ad content in an iframe on news-site.com -->
<input id="steal" type="text" style="opacity: 0; position: absolute;">
<script>
  // As soon as the ad loads, it steals focus from the parent page.
  // The user doesn't notice but keystrokes now go to this hidden input.
  document.getElementById('steal').focus();
</script>
```

The user keeps typing, believing they are interacting with the news site, but their input goes to the ad instead. This [was originally reported](https://github.com/w3c/webappsec-permissions-policy/issues/273) by engineers working on advertising security for large publishers.

### Scenario 2: App platform iframe steals focus while user is typing

A platform like Microsoft Teams embeds third-party apps in iframes. A user starts typing in the Teams search bar, but a third-party app iframe finishes loading and calls `autofocus` or `element.focus()`, pulling focus away mid-keystroke:

```html
<!-- Host app page -->
<input id="search" placeholder="Search..." autofocus>
<iframe src="https://third-party-app.example.com/"></iframe>

<!-- Inside the third-party app -->
<input id="app-input" placeholder="Message..." autofocus>
```

Keystrokes are silently redirected to the iframe. For keyboard-only users and screen reader users, this is especially disorienting.

### Scenario 3: Nested iframes in complex apps

In large web applications (Outlook, Teams, Office), the host page embeds an app iframe, which itself embeds further content. Any of these nested frames might call `element.focus()` on load, creating unpredictable focus jumps:

```html
<!-- Host: outlook.com -->
<input id="compose" placeholder="Write your email...">

<iframe src="https://todo-app.example.com/">
  <!-- Inside todo-app.example.com: -->
  <!-- <input id="new-task" placeholder="Add a task" autofocus> -->
  <!-- This autofocus steals focus from the email compose field -->
</iframe>
```

### Existing workarounds

Today, **developers have no reliable way to prevent embedded content from stealing focus**. The available workarounds are either too blunt or too fragile:

- **Sandbox attribute:** Using the `sandbox` attribute without `allow-scripts` would prevent scripted focus, but it also disables JavaScript entirely, breaking most embedded content:

    ```html
    <!-- This blocks focus stealing, but also breaks the entire widget -->
    <iframe src="https://partner-widget.example.com/" sandbox></iframe>
    ```

    If you re-enable scripts with `sandbox="allow-scripts"`, the iframe can steal focus again. This mechanism gives no fine-grained control over focus behavior.

- **JavaScript focus-reclaiming hacks:** Some developers use `blur` event listeners or polling to fight back against focus theft:

    ```js
    const searchInput = document.getElementById('search');

    window.addEventListener('blur', () => {
      // Heuristic: if we lost focus, try to take it back
      setTimeout(() => {
        if (document.activeElement === document.body) {
          searchInput.focus();
        }
      }, 100);
    });
    ```

    This approach is unreliable: it creates visible focus flickering, races with legitimate user interactions (what if the user intentionally clicked the iframe?), and doesn't scale across multiple iframes.

## Goals

- Let embedders **block programmatic focus** from embedded iframes (ads, widgets, third-party apps).
- Support control via both **HTTP response headers** and the **iframe `allow` attribute**.
- **Preserve user-initiated focus.** Clicking into an iframe or tabbing with the keyboard must always work.
- Support **focus delegation**, where a focused parent frame explicitly passes focus to a child iframe.
- **Preserve focus behavior within the iframe**. When a frame already has focus (or a descendant does), it can still move focus within its own subtree, even if the policy is denied.

## Non-goals

- Blocking user-initiated focus (clicks, keyboard tabbing). This policy only restricts programmatic focus.
- Replacing the `sandbox` mechanism. This policy complements it.
- Restricting focus by default. The default allowlist is `'*'` (all origins allowed), so this is opt-in.

## Proposed Approach

### How it works

When the `focus-without-user-activation` policy is **disabled** for a document:

- `autofocus` attributes are ignored (unless the element is inserted as a result of a user gesture)
- `element.focus()` calls have no effect unless triggered by user activation
- `window.focus()` calls are blocked in the same way
- `dialog.showModal()` and popover focusing are also restricted

User-initiated focus is **never blocked**. This policy only restricts programmatic focus changes.

### Solving Scenario 1: Blocking ad focus theft with an HTTP header

A publisher can deny programmatic focus for the entire page and all embedded content using an HTTP response header:

```http
Permissions-Policy: focus-without-user-activation=()
```

With this header, an ad's `element.focus()` call silently does nothing. The user's focus stays on the article. If the user clicks on the ad, focus moves normally.

### Solving Scenario 2: Restricting a specific iframe

A host app can restrict focus on a specific iframe using the `allow` attribute:

```html
<input id="search" placeholder="Search..." autofocus>

<iframe src="https://third-party-app.example.com/"
        allow="focus-without-user-activation 'none'">
</iframe>
```

The third-party app's `autofocus` is blocked. The user's focus remains in the search bar. If the user clicks into the app, focus moves naturally.

You can also allow same-origin iframes to take focus while blocking cross-origin ones by using `'self'` instead of `'none'`.

### Focus delegation

A common pattern in app platforms is for the host page to explicitly pass focus to an embedded app after it loads. For example, in Microsoft Teams, when a user clicks "Open Copilot", Teams focuses the Copilot iframe, and the iframe then moves focus to its own input:

```html
<!-- Host page -->
<button id="open-copilot">Open Copilot</button>
<iframe id="copilot-frame" src="https://copilot.example.com/"
        allow="focus-without-user-activation 'none'"></iframe>

<script>
  document.getElementById('open-copilot').addEventListener('click', () => {
    document.getElementById('copilot-frame').focus();
  });
</script>
```

```html
<!-- Inside the iframe -->
<input id="prompt-input" placeholder="Message Copilot">
<script>
  window.addEventListener('focus', () => {
    document.getElementById('prompt-input').focus();
  });
</script>
```

A similar pattern applies in Outlook when the user opens the "To Do" sidebar. The host delegates focus to the iframe, which then focuses the "Add a task" input.

The [TPAC 2024 resolution](https://github.com/w3c/webappsec-permissions-policy/issues/273#issuecomment-2384287101) established that **focus delegation should be allowed**, meaning a focused parent frame should be able to programmatically set focus into a child iframe. Once a frame has focus, it should be able to move focus within itself. The precise semantics of this behavior are still being refined (see [Open Questions](#open-questions)).

## Alternatives Considered

### 1. `disallowprogrammaticfocus` boolean attribute on `<iframe>`

```html
<iframe src="https://ads.example.com/banner.html"
        disallowprogrammaticfocus>
</iframe>
```

**Why rejected:** This is a heavier-weight solution than a permissions policy. Sites already using permissions policies to control other behaviors (camera, microphone, geolocation) can more naturally adopt a new policy than a one-off HTML attribute. A permissions policy also allows server-side control via HTTP headers, which an HTML attribute cannot provide.

### 2. Alternative policy naming: `disallow-programmatic-focus`

```http
Permissions-Policy: disallow-programmatic-focus=()
```

**Why rejected:** Existing permissions policies use positive polarity: the policy name describes the *capability* being controlled, and denying the policy disables it. Using negative polarity (`disallow-*`) would be inconsistent with the rest of the permissions policy ecosystem.

### 3. Sandbox flag approach

Using the existing `sandbox` mechanism with a new flag:

```html
<iframe src="https://ads.example.com/banner.html"
        sandbox="allow-scripts allow-same-origin allow-focus-calls">
</iframe>
```

**Why rejected:** Adding this to the sandbox would be **potentially breaking**. It would immediately affect every sandboxed frame on the web, requiring all sites to add the new flag to restore existing focus behavior. A permissions policy with a default allowlist of `'*'` is non-breaking: focus works everywhere by default, and sites opt in to restricting it.

## Accessibility, Privacy, and Security Considerations

**Security:** This feature reduces the attack surface for input hijacking. Without it, a malicious iframe can silently capture keystrokes by focusing a hidden input. The policy lets embedders prevent this.

**Accessibility:** Unexpected focus changes are disorienting for all users, but especially for screen reader users and keyboard-only users who rely on predictable focus order. This policy prevents embedded content from disrupting that focus order without a user gesture.

**Privacy:** This policy does not expose any new information. It restricts behavior (programmatic focus) rather than granting access to data. No new privacy surfaces are introduced.

## Stakeholder Feedback / Opposition

- Chromium: Positive ([Chrome Status Page](https://chromestatus.com/feature/5179186249465856))
- Gecko (Firefox): No signals ([mozilla/standards-positions#1080](https://github.com/mozilla/standards-positions/issues/1080))
- WebKit (Safari): Positive ([WebKit/standards-positions#406](https://github.com/WebKit/standards-positions/issues/406))
- W3C TAG: Review satisfied ([w3ctag/design-reviews#1066](https://github.com/w3ctag/design-reviews/issues/1066))

## Open Questions

1. **Focus delegation from parent to policy-denied child.** When a parent frame (with the policy allowed or that's currently focused) calls `element.focus()` on a child iframe that has the policy denied, should this be allowed? The current spec checks the *target's* policy, which blocks this. The proposed fix is to check the *caller's* policy instead, aligning with the TPAC 2024 resolution. See [whatwg/html#12032](https://github.com/whatwg/html/issues/12032).

2. **Descendant focus behavior.** If a frame has the policy denied but already has focus (because the parent delegated focus to it), can it move focus within itself and its child iframes? Real-world use cases (Teams embedding Copilot, Outlook embedding ToDo) depend on this working. See [whatwg/html#11519](https://github.com/whatwg/html/pull/11519) and [whatwg/html#11839](https://github.com/whatwg/html/issues/11839).

## References

- [Original issue: w3c/webappsec-permissions-policy#273](https://github.com/w3c/webappsec-permissions-policy/issues/273)
- [TPAC 2024 resolution about focus delegation](https://github.com/w3c/webappsec-permissions-policy/issues/273#issuecomment-2384287101)
- [WHATWG HTML Standard: allow focus steps](https://html.spec.whatwg.org/#allow-focus-steps)
- [whatwg/html#10672](https://github.com/whatwg/html/pull/10672) (first spec PR, merged March 2025)
- [whatwg/html#11519](https://github.com/whatwg/html/pull/11519) (descendant focus behavior PR)

## Appendix

### A1. Policy Pseudo-Algorithm

This describes the proposed core logic of the `allow focus steps` in the [WHATWG HTML Standard](https://html.spec.whatwg.org/#allow-focus-steps):

```python
def allow_focus(focus_setter_frame, target_frame, currently_focused_frame):
    # If the frame initiating focus has the policy allowed, always permit.
    if focus_setter_frame.has_policy_allowed():
        return True

    # If the user initiated the action, always permit.
    if target_frame.has_transient_activation():
        return True

    # If the frame already has focus (or a descendant does),
    # allow it to move focus within its subtree.
    if currently_focused_frame.is_inclusive_descendant_of(focus_setter_frame):
        return True

    return False
```

An [inclusive descendant](https://html.spec.whatwg.org/#inclusive-descendant-navigables) frame is a frame that is either the same frame or a descendant frame in the frame tree hierarchy.

### A2. Spec Integration Points

By modifying the [allow focus steps](https://html.spec.whatwg.org/multipage/interaction.html#allow-focus-steps), the policy integrates with the following spec algorithms:
- **autofocus:** Around step 5 of the [autofocus processing](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#attr-fe-autofocus), the algorithm returns early if the policy is disabled and the action is not triggered by user activation.
- **element.focus():** At step 1 of the [element focus algorithm](https://html.spec.whatwg.org/multipage/interaction.html#dom-focus), before running the [focusing steps](https://html.spec.whatwg.org/multipage/interaction.html#focusing-steps), the same policy and user activation check is performed.
- **window.focus():** Around step 3 of the [window focus algorithm](https://html.spec.whatwg.org/multipage/interaction.html#dom-window-focus), the same enforcement applies.
- **dialog.showModal() and popover focusing:** The [dialog focusing steps](https://html.spec.whatwg.org/multipage/interactive-elements.html#dialog-focusing-steps) and [popover focusing steps](https://html.spec.whatwg.org/multipage/popover.html#popover-focusing-steps) also respect the policy.

### A3. Focus Behavior Cases

Example cases showing how focus works with the policy:

| Case | Policy Allowed on Setter | Setter Frame | Currently Focused Frame | Allowed? | Reason |
|------|--------------------------|--------------|-------------------------|----------|--------|
| 1 | No | Parent | Child | Yes ✅ | Focus is on a descendant of the setter, so moving within the subtree is allowed. |
| 2 | No | Child | Parent | No ❌ | Child cannot steal focus from parent without policy or user activation. |
| 3 | No | Grandparent | Grandchild | Yes ✅ | Focus is on a descendant of the setter. |
| 4 | No | Grandchild | Grandparent | No ❌ | Cannot steal focus from ancestor without policy or user activation. |
| 5 | No | Same frame | Same frame | Yes ✅ | Frame already has focus, can move focus within itself. |
| 6 | Yes | Parent | Child | Yes ✅ | Policy explicitly allows. |
| 7 | Yes | Child | Parent | Yes ✅ | Policy explicitly allows. |
| 8 | Yes | Grandparent | Grandchild | Yes ✅ | Policy explicitly allows. |
| 9 | Yes | Grandchild | Grandparent | Yes ✅ | Policy explicitly allows. |
| 10 | Yes | Same frame | Same frame | Yes ✅ | Policy explicitly allows. |