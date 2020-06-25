# Document Policy

This is a proposal for a mechanism, similar to Feature Policy, to cover those
kinds of features which don't involve delegation of permission to trusted
origins; features which are more about configuring a document, or removing
features (sandboxing) from a document or a frame.



## Start with Examples!

### Performance best practices

The simplest example is a site which wants to enforce some performance
best-practices on their own content.

Example Magazine wants to ensure that the documents produced by all of its
writers and editors load quickly and become responsive to the user as soon as
possible. They decide that there are several techniques that they can use to
achieve this:

  * Require that all images have a minimum compression ratio, to keep their
    sizes small.
  * Require that all images have declared dimensions in markup, to avoid
    unnecessary relayouts,
  * Disable the use of document.write, to avoid blocking the HTML parser
  * Make all subframes load lazily by default.

They can do this by serving their HTML content with this HTTP header:

```http
Document-Policy: unsized-media=?0, document-write=?0,
                 max-image-bpp=2.0, frame-loading=lazy
```

A document served with this header may embed other content, first- or
third-party, and that content will not be subject to those restrictions. That
content may include its own `Document-Policy` header, but the headers do not
combine in any way.

### Enforcing performance best practices on embedded content

Example Magazine also has a partner whose pages they embed using iframes. In
order to ensure good performance, Example Magazine would like to be sure that
the image policies are also being enforced by their partner's pages. Example
Magazine's HTTP header from the last example only affects their own content, but
they can use an iframe attribute to request that a minimum policy be in effect
in that frame:

```html
<iframe src="https://img.example.com/"
        policy="unsized-media=?0, max-image-bpp=2.0">
```

Since a document policy like this can affect a site's behavior, perhaps in ways
that the embedded partner didn't expect, Example Magazine can't just impose the
policy. Instead, there is an HTTP exchange that happens behind the scenes, to
ensure that the partner is told about the requested policy, and gets to choose
whether or not to comply.

When the embedded document is loaded over the network, the request will look
something like this (abbreviated):

```http
GET / HTTP/1.1
Host: img.example.com
Sec-Required-Document-Policy: unsized-media=?0, max-image-bpp=2.0
```

The response will need to have a conforming header in order to be loaded, so a
document served with this header would work:

```http
Document-Policy: max-image-bpp=1.5, document-write=?0, unsized-media=?0
```

While either of these headers would cause a network error to be returned
instead:

```http
Document-Policy: unsized-media=?0, max-image-bpp=3.0
Document-Policy: max-image-bpp=2.0
```

To ensure that there's no cheating, if the user clicks a link inside the
embedded page and it navigates the frame to a new document, that new document
will have the same required policy, and will have to play out the same header
dance.  Similarly, if the embedded page embeds subframes of its own, the same
requirements will apply to them.

### Deeper nesting

Let's take a closer look at what that last sentence implies.

If Example Magazine embeds its image server partner with the iframe tag:

```html
<iframe src="https://img.example.com/"
        policy="unsized-media=?0, max-image-bpp=2.0">
```

Then the page at img.example.com will need to be served with a Document-Policy
header that represents a policy at least as strict as that. If img.example.com
then embeds an advertisement, with a tag like:

```html
<iframe src="https://ads.example.com/">
```

then Example Magazine's required policy will still be in effect. The request
will go out with a `Sec-Required-Document-Policy` header, and that document will
*also* need to conform to the policy to be loaded. *Any* document loaded inside
of the frame that Example Magazine set up will need to do the same.

Now, the img.example.com page can also set a stricter policy for itself; it
doesn't have to be an exact match: If the partner site knows that the images
it serves have even better compression, it could set its own policy like this:

```http
Document-Policy: unsized-media=?0, max-image-bpp=1.5
```

But that doesn't have any effect on the requirements for its embedded frames.
They still have the same requirements that were set by the top-level document.

If it wanted to, img.example.com could set a different policy for its ads -- it
could embed them with

```html
<iframe src="https://ads.example.com/" policy="max-image-bpp=1.25">
```

In that case, the advertisement will have a stricter required policy, which it
will need to conform to in order to be loaded.


Finally, note that the required policy for the advertisement in this example is
the *combination* of the `policy` attribute and the required policy of its
parent; it's not just one or the other.

As an example, if img.example.com had a required policy (set by Example
Magazine) of

```
max-image-bpp=2.0
```

and it included an advertisement in a frame with a policy attribute of

```
max-image-bpp=4.0, document-write=?0
```

Then the required polcicy which the browser would compute for the advertisement
frame would contain the strictest value for each feature:

```
max-image-bpp=2.0, document-write=?0
```


### Sandboxing nested content (Traditional sandbox)

Document policy can also be used to control features which are traditionally
managed through `<iframe sandbox>`, though in a more flexible way.

Every sandbox feature can be defined as a document policy feature with a
similar name. "`allow-scripts`", for instance, can be controlled as "`scripts`"
in a document policy. "`allow-presentation-lock`" can be controlled as
"`presentation-lock`", etc.

This means that sandbox features can be applied individually to iframes which
are not otherwised sandboxed:

```html
<iframe policy="scripts=?0">
```

Since the `policy` attribute creates a frame with a Required Policy, which
applies to all content in the frame, this works exactly like a frame defined as:

```html
<iframe sandbox="allow-same-origin allow-forms allow-presentation-lock allow-...">
```

(with every attribute except for "`allow-scripts`" specified.)


In this model, the `sandbox` attribute still exists, and is a shorthand for
specifying a policy which disables all of the pre-defined sandbox features.

As examples of different ways to sandbox content using a combination of the
`sandbox` and `policy` attributes, the following could all be used to create a
sandboxed iframe:

```html
<iframe sandbox>
<iframe sandbox="allow-scripts allow-forms">
<iframe policy="scripts=?0">
<iframe sandbox policy="scripts"> (Should this be allowed?)
<iframe sandbox="allow-scripts" policy="scripts=?0"> (This one needs some work)
<iframe policy="same-origin=?0"> (This is a frame with an opaque origin, but no other sandboxing)
```

None of these result in a `Sec-Required-Document-Policy` header, as all of the
existing sandbox features are safelisted.

However, new features are not safelisted, and so would result in a header if any
of them are restricted:

```html
<iframe policy="scripts=?0, document-write=?0">
```

results in a request header:

```http
Sec-Required-Document-Policy: document-write=?0
```

(Note that `scripts=?0` is not present in the header; only those values which
are required to appear in the response header are listed.)

The sandbox attribute in an iframe tag serves to disable all of the
currently-defined sandbox features. These can also be toggled individually with
the policy attribute:

```html
<iframe policy="document-write=?0, escape-in-popups=?0">
```

They can also be set from an HTTP header:

```http
Require-Document-Policy: forms=?0
```

Would impose the sandboxed forms browsing context flag on all nested content.

### Sandboxing yourself

```http
Document-Policy: popups=?0, modals=?0, presentation-lock=?0, forms=?0,
                 pointer-lock=?0
```

In this case (like in the first document policy example), the document may embed
other content without these restrictions.

You can also include both headers, to sandbox yourself as well as all nested
content:

```http
Document-Policy: popups=?0, modals=?0, presentation-lock=?0, forms=?0, pointer-lock=?0
Require-Document-Policy: popups=?0, modals=?0, presentation-lock=?0, forms=?0, pointer-lock=?0
```

## Use cases -- what's this good for?

Document policy is a generic framework, so it's only as useful as the things
which can be controlled by it. That is a still-evolving set of ideas, but some
of the things which have been considered are:

 * Enforcing performance best-practices

   The first examples in this explainer focus on this use case. The web platform
   is extremely relaxed in what kinds of content it allows, happily downloading
   enormous images to display in tiny containers, or documents with tens of
   megabytes of associated resources, scripts, images, and other content. It
   still supports slow, synchronous, decades-old APIs which can slow down sites
   which use them, and whose presence makes some potential browser optimizations
   impossible.

   Document policy allows documents to voluntarily restrict these behaviors,
   enforcing use of best practices, and potentially opening up possibilities for
   browsers to make otherwise unfeasable optimizations.

 * Re-defining iframe sandboxing

   Also discussed above, the model followed by Document Policy, when used in the
   `policy` attribute to set a required policy on a frame, is combatible with
   existing iframe sandboxing, and that sandboxing can be redefined to make use
   of document policy as the underlying mechanism. This additionally allows the
   individual features to be used outside of sandbox, in otherwise unsandboxed
   frames.

 * Per-page opt-out of new features

   As new features are added to the web platform, document policy is proposed as
   a mehanism for individual pages to opt out, in cases where they know that a
   feature could interact badly with existing content. As a concrete example,
   document policy is proposed as the opt-out mechanism for the
   [Scroll-to-text](https://github.com/WICG/ScrollToTextFragment) feature.
   (Feature policy was previously proposed for this kind of opt-out, but feature
   policy's semantics make this less flexible, as disabling a feature in one
   document necessarily disables it in all of that document's children, with
   no notice to the embedded content; a model much more suitable for restricting
   delegation of powerful features than for a per-document opt-out.)

 * New sandboxing and security measures

   It is difficult for the web community to add new features to the iframe
   sandboxing model, as its deny-all-then-re-enable pattern means that any new
   features included in the sandbox will be immediately blocked in all existing
   sandboxed content, potentially breaking existing web content. This
   effectively limits new sandbox features to just those for which there is
   universal agreement that a feature (which is otherwise available to the
   entire web) is too powerful to give to any untrusted content. As we come up
   with new examples of existing features which developers *may* want to remove
   from certain contexts, document policy allows them to be defined in a way
   which lets developers make that choice.

 * Configuring new web platform features

   Finally, there are new features being proposed which have a degree of
   flexibility in their behaviour, where different kinds of documents may have a
   legitimate need for different behaviour.
   [Image and frame lazy loading](https://github.com/scott-little/lazyload) is
   an example of this, where lazy loading is not an automatic performance
   improvement for every page. Some kinds documents may need eager loading to be
   the default, while others will perform better with lazy-by-default semantics.
   Document policy allows lazy loading to be defined as a configurable feature,
   where the header determines the default behaviour in each frame.

## So, how does it work?

(This section glosses over many algorithms and other details, some of which may
even be important.  For all of the details, see the
[spec](https://w3c.github.io/webappsec-feature-policy/document-policy.html).)

`Document-Policy` is an HTTP response header that sets the policy on the
document which it is served with. You can use it to set things like restrictions
on image sizes or compression ratios, lazy frame and image loading policies, use
of synchronous APIs, or use of APIs that fall under iframe sandboxing,
traditionally.

That header doesn't impose any restrictions on content which the document embeds
at all, and in the base case, every document is free to set its own policy
independently.

(In a minute, we'll talk about required policies, though - and not conforming
to a required policy might impact your page's ability to be loaded, but in
general, you're free to set your policy any way you like)

Policies controllable with this mechanism include things like document
configuration, and sandboxing. Each of them can be named with a unique string.

Examples:

* `image-compression`
* `frame-loading`
* `vertical-scroll`
* `popups`
* `document-write`
* `scripts`

Some policies are boolean switches, which can be enabled by simply naming them,
and disabled with the false value "?0":

* `popups`
* `popups=?0`
* `scripts`
* `no-scripts=?0`
* `document-write`
* `document-write=?0`

Others take parameters, whose types are specific to each policy:

* `max-image-bpp=2.0`
* `frame-loading=lazy`

All of the directives can be combined with commas into a single header. In
Structured-header-speak, this is a Dictonary.

### Requiring a policy in your embedded content

It is possible to enforce that content you embed conforms to a specific policy
as well. This can be done in two ways: either through a different response
header (`Require-Document-Policy`), which affects every iframe on your page; or
by using a "`policy`" attribute on specific frames, which target just those
frames.

`Require-Document-Policy` doesn't affect the document that it is returned with,
just the content that it embeds. It can be used in conjunction with the
`Document-Policy` header, though.

When you set a required document policy, it will have to be acknowledged by the
document being embedded, as otherwise it would be possible to affect the content
on that page in unexpected ways. The required policy will be advertised with a
`Sec-Required-Document-Policy` request header.

If the content which is returned doesn't have a `Document-Policy` header which
is at least as strict as the `Sec-Required-Document-Policy`, then it will not be
loaded into the frame, and a network error will result instead.

The `Sec-Required-Document-Policy` header will be present for all requests for
documents in a frame, at every nesting level. If the framed document adds its
own `Require-Document-Policy` header, or uses the policy attribute on its own
iframes, then the requirements will be combined in deeper requests, to ensure
that all content meets all of the requirements being imposed on it.

### Extending the Iframe Sandboxing Mechanism

All existing sandbox features can be defined as document policies as well. The
iframe `sandbox` attribute will disable all of them by default, but they can be
turned back on either with the `policy` attribute or the `sandbox` attribute.
Additionally, they can be disabled individually, even on frames which are not
otherwise sandboxed.

Any new sandbox-style features can be added through this mechanism, without
having to add them to the set of features disabled by the sandbox attribute.

### Resetting policies in popups

There is currently a sandbox flag, the
*sandbox propagates to auxiliary browsing contexts flag*, which controls whether
the existing sandbox features should be inherited in popups opened from a
sandboxed frame. This flag can continue to function as it currently does, and
can be extended to cover the entire required document policy. This flag itself,
as a sandbox flag, can be controlled independently as well.

### More Details: Opting in to being embedded with a policy

Document policy features require acknowledgment when they are part of a required
policy -- that is, a page cannot simply set the "`policy`" attribute on an
iframe and impose the requirement on the page in the frame. The page being
embedded must be serverd with its own `Document-Policy` header which
acknowledges the requirement (specifying a policy which it at least as strict).

In documents generated from `data:` URLs, and in iframe srcdoc documents, where
the parent document controls the content of the child explicitly, and there is
no HTTP network transfer, the acknowledgment will simply be implied.

There is a ***required document policy*** associated with every browsing
context.

For an iframe, that required policy is the union<sup>[1](#fn1)</sup> of the
parent's required document policy, the parent's `Require-Document-Policy`
header, and the policy attribute of the containing iframe element.

The required policy will be advertised in a `Sec-Required-Document-Policy`
request header.

Example:

```http
Sec-Required-Document-Policy:
     document-write=?0, storage=?0, max-image-bpp=4.0
```

If the response does not have a document policy response header which conforms
to that request header, it will not be loaded. Instead, a network error will be
returned instead, similar to CSP.

Note: This does not mean strictly increasing strictness: the following would work:

* Top-doc contains `<iframe policy="max-image-bpp=4.0">`
  * First nested doc uses header `max-image-bpp=2.0` (okay)
    * Second nested doc uses header `max-image-bpp=3.0` (looser, still okay)

A document's final policy is the union<sup>[1](#fn1)</sup> of its browsing
context's required policy and it's own header policy. (If it weren't for
non-opt-in-required policies, the union wouldn't be required; we could just use
the header policy as-is).

<a name="fn1">1</a>: Note that "union" isn't exactly the right word for the
combination operation used here; it's something of a "strictest union", where we
take the strictest value from both sides, independently for each feature. This
should be spelled more explicitly still, in a proper spec.
