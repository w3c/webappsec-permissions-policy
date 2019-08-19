# Iframe Sandboxing with Feature Policy

## Background

HTML defines a sandbox mechanism for restricting a set of powerful features in
iframes. This mechanism gives a designated frame an opaque origin (which makes
it cross-origin with every other document, and therefore unable to access any
other frames in the same page) as well as disabling a number of features. These
restrictions can be relaxed by the embedding page, but once they are applied to
a frame, any frames that it embeds will inherit the same restrictions.

Feature Policy defines another mechanism for generally allowing and restricting
features in frames. Similarly to sandboxing, the set of features which should be
restricted can be set by the embedding page, and once applied to a frame, any
further-nested frames will inherit the same restrictions.

Sandboxing has a few limitations which are not present in feature policy: It can
only be applied to iframes, not to frames in general; it includes some
restrictions which cannot be relaxed at all; and the set of features which it
disables is determined by the browser, rather than the site owner. If a new
version of the browser introduces an additional feature to sandbox, that feature
will be disabled in every sandboxed frame until site owners update their sites
to re-enable it if it is needed.

Feature Policy, on the other hand, can be applied to any frame, not just
sandboxed iframes. New features can be added to the platform without affecting
existing content, because existing features can be declared to be available by
default to all web content, and the site owner can declare what features should
be restricted in a frame. Additionally, Feature Policy can be used to either
restrict every document loaded into a frame, or allow it just for certain
origins (and disallow it again if the user or the page navigates away from one
of those trusted domains)

## Proposal

Since there is significant overlap in behavior between sandbox features and
Feature Policy's policy-controlled features, I'm proposing that all of the
current sandbox features, with the exception of the cross-origin restriction
provided by the `sandbox` attribute itself, become policy-controlled features
as well.

## Policy-controlled sandbox features

The new features added to feature policy to support sandboxing are:

* "`forms`"
* "`modals`"
* "`orientation-lock`"
* "`plugins`"
* "`pointer-lock`"
* "`popups`"
* "`presentation`"
* "`scripts`"
* "`top-navigation`"
* "`downloads-without-user-activation`"

All of these features have a default allowlist of `*`, meaning that they are
allowed by default in all web content.

## How does this work?

With this in place, the `sandbox` attribute still has two important roles to
play: The first, which is not a part of feature policy, is that it gives the
content loaded in the frame an opaque origin, which is guaranteed not to be
same-origin with any other origin, including that of its parent and its child
frames. (This is overridable with the `allow-same-origin` keyword.)

Secondly, the `sandbox` attribute defines a set of features which are disabled
in the embedded frame through feature policy. This specifcally includes all of
the new features listed above, in addition to any other behaviours which
`sandbox` should completely disable (such as plugins).

These features are disabled by constructing a container policy for an iframe,
based on its `sandbox` attribute, in addition to its `allow` attribute:

```html
<iframe sandbox></iframe>
```

will apply a container policy to the frame as if the `<iframe>` tag had been
written like

```html
<iframe allow="top-navigation 'none'; forms 'none'; scripts 'none';
               popups 'none'; pointer-lock 'none'; modals 'none';
               orientation-lock 'none'; presentation 'none'; plugins 'none'"></iframe>
```

### Sandbox keywords

The `sandbox` attribute's `allow-*` keywords, if used, can each remove an item
from this constructed container policy. An `<iframe>` written like

```html
<iframe sandbox="allow-scripts allow-modals"></iframe>
```

will omit the "`scripts`" and "`modals`" features from the constructed
container policy, as if it had been written like

```html
<iframe allow="top-navigation 'none'; forms 'none'; popups 'none';
               pointer-lock 'none'; orientation-lock 'none';
               presentation 'none'; plugins 'none'"></iframe>
```

In the limit, every sandbox `allow-` keyword could be specified, and the
container policy constructed for the frame would list no features. The only
effect that the `sandbox` attribute would have in that case would be to disable
plugins in the frame.

### Sandbox keywords which do not correspond to features

There are two keywords for the `sandbox` attribute which do not correspond
directly to policy controlled features, and retain their existing behaviour:

* `allow-same-origin`: The presence of this keyword indicates that the embedded
   frame will not get an opaque origin, but will use the origin it would have
   had if the `sandbox` attribute had not been present.
* `allow-popups-to-escape-sandbox`: This keyword does not enable any particular
   feature, but instead indicates that any new windows or tabs created by the
   frame will get a new default feature policy, rather than inheriting the
   policy of the frame that created them.

Note that there is no `allow-plugins` keyword; the "`plugins`" feature cannot
be re-enabled in sandboxed frames.

## Backwards compatibility

This implementation of sandboxing is backwards-compatible with existing web
content, and provides the same behavior as in browsers which do not support
feature policy, and in those which do but do not implement sandboxing through
feature policy. The behaviour of the sandbox attribute by itself is unchanged.

Features which are disabled by sandbox remain disabled in child frames of the
sandboxed frame, and cannot be re-enabled. Changes to the `sandbox` attribute,
like changes to the `allow` attribute, do not take effect instantly, but affect
the contents of the frame as soon as it is navigated or reloaded.

## Combining sandboxing and Feature Policy

As described above, specifying the ‘sandbox’ attribute on an iframe element
will result in a container policy with all of the sandbox features disabled for
that frame. Those restrictions will be in place for that frame and any of its
descendant frames, since Feature Policy does not allow features, once disabled,
to be re-enabled in child frames.

Individual features can be re-enabled in a sandboxed frame in one of two ways:
Either by using the appropriate sandbox attribute keywords, *or* by specifying
the features in the iframe's “allow” attribute.

For example, both of these two sandboxed frames will be allowed to execute
scripts:

```html
<iframe sandbox="allow-scripts"></iframe>
<iframe sandbox allow="scripts"></iframe>
```    

Either of those mechanisms will cause the "‘scripts’" feature to be omitted from
the container policy constructed for the frame.

Note that no other mechanism will turn on a sandboxed feature in a frame. The
container policy for the frame will override both the effective feature policy
of the containing document, and any policy delivered with the sandboxed content.

Example:
With this top-level document:

```html
<!DOCTYPE html>
<html>
  <body>
    <iframe sandbox src="example.html"></iframe>
  </body>
</html>
```

Even if `example.html` is served with the headers:

```http
Content-Type: text/html
Feature-Policy: scripts *
```

It will not be able to run scripts. Similarly, if `example.html` contains
another `iframe` tag, like this:

```html
<!DOCTYPE html>
<html>
  <body>
    <iframe allow="scripts" src="nested-example.html"></iframe>
  </body>
</html>
```

The document in the nested frame will *still* not be allowed to run scripts.

Similarly, when sandbox features are set in the HTTP response headers, the value set
through feature policy headers takes precedence over that of content security policy.
For example, if the response contains:
```
Content-Security-Policy: sandbox allow-popups
Feature-Policy: popups 'none'
```

the `popups` feature will be disabled for the entirety of the document and nested and
auxiliary browsing contexts; a popup cannot be opened.

### Resolving conflicts

If both `allow` and `sandbox` are present, and both mention the same feature,
then the allowlist specified by the `allow` attribute will take precendence over
the sandbox attribute.

Examples:

```html
<!-- Both attributes mention scripts: allow takes precedence, and the content is
     not allowed to execute scripts. -->
<iframe sandbox="allow-scripts" allow="scripts 'none'"></iframe>

<!-- Both attributes mention scripts: allow takes precedence, and the content is
     only allowed to execute scripts when pointed at a particular origin. -->
<iframe sandbox="allow-scripts allow-same-origin"
        allow="scripts https://example.com"></iframe>
```
### Special handling for plugins

The "`plugins`" feature should be disabled in all sandboxed frames, and should
not be able to be re-enabled. (This has always been the case with sandboxes, and
this should not change that fact.) 

To support this, the precedence is changed in this one case: If the `sandbox`
attribute is present, the "plugins" feature will be disabled, and this will
override any mention of plugins in the "allow" attribute.

```html
<iframe sandbox allow="plugins"></iframe>
```

will not be allowed to use plugins.

## Using sandbox features without sandboxing

It is also possible to apply sandbox restrictions to arbitrary frames, without
needing to sandbox them. For instance, an iframe could be restricted from using
the pointer-lock feature just by including a policy like this:

```html
<iframe allow="pointer-lock 'none'" src="..."></iframe>
```

Similarly, the use of scripting, plugins, HTML forms, or any other feature
currently only controlled by sandboxing, could be restricted with a policy.

Top-level documents can be easily restricted as well; a document could restrict
its own use of modal dialogs, by being served with an HTTP header:

```http
Feature-Policy: modals 'none'
```
