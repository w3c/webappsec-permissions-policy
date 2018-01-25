# Defining Policy-Controlled Features

This guide is for authors of other standards who want to use Feature Policy as
a mechanism for enabling and disabling their features. It's a collection of
principles and guidelines (more than actual rules) for coming up with sensible
defaults, whether the feature in question is a long standing feature on the
web, or something brand new.

## Referencing the Feature Policy spec

There is no central registry for policy-controlled features. Feature authors who
wish to allow Feature Policy to control their features on the web can do so by
referencing the Feature Policy specification.

The following example shows how a feature could be declared as a
policy-controlled feature:

> Example:
>
>### Section N: Feature Policy Integration
> The Sample API defines a [*policy-controlled feature*](https://wicg.github.io/feature-policy/#policy-controlled-feature)
> identified by the string "`sample`". Its [default allowlist](https://wicg.github.io/feature-policy/#default-allowlist)
> is `'self'` \[[FEATURE-POLICY](https://wicg.github.io/feature-policy/)\].

The specification can then refer to this feature, and test whether it is enabled
or not in a specific document, with text similar to this:

> Example:
>
> If the [responsible document](https://html.spec.whatwg.org/multipage/webappapis.html#responsible-document)
> is not [allowed to use](https://html.spec.whatwg.org/multipage/iframe-embed-object.html#allowed-to-use)
> the `sample` feature, then throw a `SecurityError`
> [DOMException](https://heycam.github.io/webidl/#dfn-DOMException) and abort these steps.

(This is an example only. The actual behavior of any algorithm when a
policy-controlled feature is disabled is left up to the specification which
defines that feature.)

## Choosing a default allowlist

As described in the
[spec](https://wicg.github.io/feature-policy/#default-allowlists), the default
allowlist chosen affects how the feature behaves when there are no declared
policies present. As a rough guide:

* Features which have already been widely available on the web platform, but
which Feature Policy can now disable selectively, should use `*`. This
ensures that the majority of documents on the web, as well as documents which
are framed without their knowledge, will continue to behave as expected by
their original authors.
* New powerful features are often specified such that they are available in
top-level browsing contexts only, and are not available in cross-origin child
frames, for security. These kinds of features should use a default allowlist of
`'self'` to provide this behaviour. In this case, Feature Policy also grants
site authors the ability to selectively enable the feature in other origins,
but the default behaviour is to disable it.
* A default allowlist of `'none'` should be restricted to new features, as a
Feature Policy header is *required* in order to enable it in any document.

## Considerations for behavior when disallowed

It is important for feature authors to carefully consider the mechanism by
which their feature is disabled when disallowed in a document, for ease of
developer feature detection, as well as for compatibility with existing web
content.

Existing web platform features which already have some mechanism for reporting
errors, or signalling that the user chose not to grant permission, should use
those existing mechanisms when disabled.

New features should attempt to fail in a way which allows authors to detect
that the feature is disabled.

> Example:
>
> The fullscreen API has existed on the web for some time, and is being
> implemented as a policy-controlled feature. Developers have always had to
> contend with the fact that fullscreen may not be allowed, and the API has a
> method of signalling that.
>
> As a policy-controlled feature, the fullscreen API can specify that when
> disabled, `document.fullscreenEnabled` must return `false`, and
> `Element.requestFullscreen()` must fire a `fullscreenerror` event, and return
> a promise which rejects with a `TypeError` exception.

If an existing feature has no mechanism for reporting failure, or has never been
allowed to fail in the past, then it may be dangerous to turn it into a
policy-controlled feature, where it may start to fail on pages that were always
able to assume that it would not.

In this case, features can take advantage of the concept of
[feature-policy-awareness](https://wicg.github.io/feature-policy/#feature-policy-aware)
to define different behaviour when disabled in a document written to be aware of
Feature Policy (and hence the possiblity that the API could fail) and in a
document written without that knowledge.

> Example:
>
> The `document.write` API has existed on the web since roughly the dawn of
> JavaScript, and has no failure modes.
>
> One means of disallowing this feature via Feature Policy would be to declare that
> any calls to `document.write()` will silently fail. However, this would mean that
> if a page contained a script like this:
>
>     <html>
>       <head>
>         <script>document.write('<script src="important-security-feature.js"></scr'+'ipt>')</script>
>         ...
>
> then an attacker could embed that page in a frame with the `document.write`
> feature disabled, and bypass the critical security script.
>
> To avoid this, a better way to disable it woudl to to declare that, if
> disallowed in a *feature-policy-aware* document, calling `document.write()` will
> fire a `SecurityError` exception on the `document` object, but if disallowed in
> a *feature-policy-oblivious* document, calling `document.write()` API must cause
> the current page to be navigated to an error page which provides the option to open
> the page that violated the policy in a new top-level browsing context.

## Allow versus Deny features

In some cases, when defining a new policy-controlled feature, it may not be
obvious whether allowing or restricting an action should be considered the
feature.

In a case like this, consider that Feature Policy tries to guarantee that, once
disabled in a document, a feature -- however defined -- cannot be reenabled in
that document or any of its children.

> As an example, if a browser was considering a feature which would block the
> loading of any images which appeared to be pictures of cats (as a
> productivity measure,) and wanted to make this a policy-controlled feature,
> then the developers would have a choice -- whether to define the new feature
> as "block cat pictures", or as "load cat pictures".
>
> If the goal is to block cat pictures, such that they cannot be loaded into a
> document at all, then defining the feature as "load cat pictures" makes
> sense, and the feature would be given a default allowlist of `*`. This way,
> cat pictures would be allowed by default on the entire web, but once disabled
> in a document, would not be available anywhere in that document, even in
> child frames.

In general, framing features in the positive sense, as 'allow' rather than 'deny',
will be the right choice. This also avoids potentially-confusing double-negatives,
and means that features will behave more consistently with each other.
