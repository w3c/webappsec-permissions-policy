# Feature Policy: Document Policies

This is a proposal for an extension to Feature Policy to cover those kinds of
features which don't involve delegation of permission to trusted origins;
features which are more about configuring a document, or removing features
(sandboxing) from a document or a frame.

## Start with Examples!

### Performance guardrails

The simplest example is a site which wants to enforce some performance
best-practices on their own content. They can do this by serving their HTML
content with this HTTP header:

```http
Document-Policy: no-unsized-media, no-document-write,
                 image-compression;bpp=2, frame-loading;lazy
```

A document served with this header may embed other content, first- or
third-party, and that content will not be subject to those restrictions. That
content may include its own `Document-Policy` header, but the headers do not
combine in any way.

### Enforcing performance guardrails on embedded content

In this example, the top level document wants to ensure that the content loaded
into a particular frame uses best practices regarding its images. All images
should have declared sizes, and should be reasonably compressed. It includes an
iframe tag like this:

```html
<iframe src="https://img.example.com/"
        policy="no-unsized-media,image-compression;bpp=2">
```

When the document is loaded over the network, the request will look like this
(abbreviated):

```http
GET / HTTP/1.1
Host: img.example.com
Sec-Required-Document-Policy: no-unsized-media,image-compression;bpp=2
```

The response will need to have a conforming header in order to be loaded, so a
document served with this header would work:

```http
Document-Policy: image-compression;bpp=1.5,no-document-write,no-unsized-media
```

While either of these headers would cause a network error to be returned
instead:

```http
Document-Policy: no-unsized-media,image-compression;bpp=3
Document-Policy: image-compression;bpp=2
```

If the document is successfully loaded, any subsequent navigations from that
frame will also have their requests sent with the same
`Sec-Required-Document-Policy` header.

### Deeper nesting

As above, if the top-level document uses the policy attribute in an iframe
element, like this:

```html
<iframe src="https://img.example.com/" policy="image-compression;bpp=2">
```

Then the request for the frame will look like this:

```http
GET / HTTP/1.1
Host: img.example.com
Sec-Required-Document-Policy: image-compression;bpp=2
```

If the framed document then includes its own subframes, they will be sent with
the same `Sec-Required-Document-Policy` header, as the policy set by the
top-level document applies to all nested iframes within.

If the framed document then also applies a policy attribute to its iframes, then
the required policy indicated by those frames will combine with the required
policy imposed on the document itself.

A document like this:

```html
<html>
  <body>
    <iframe src="https://a.example.com/" policy="no-unsized-media"></iframe>
    <iframe src="https://b.example.com/"
            policy="image-compression;bpp=1"></iframe>
    <iframe src="https://c.example.com/"
            policy="image-compression;bpp=4"></iframe>
  </body>
</html>
```

Would result in these three (simplified) HTTP requests:

```http
GET / HTTP/1.1
Host: a.example.com
Sec-Required-Document-Policy: image-compression;bpp=2,no-unsized-media
```

```http
GET / HTTP/1.1
Host: b.example.com
Sec-Required-Document-Policy: image-compression;bpp=1
```

```http
GET / HTTP/1.1
Host: c.example.com
Sec-Required-Document-Policy: image-compression;bpp=2
```

(Note that in the last example, the stricter requirements imposed by the
top-level document subsume the requirements on the nested frame, so the combined
threshold value is still 'bpp=2'.)

### Sandboxing nested content (Traditional sandbox)

As examples of different ways to sandbox content using a combination of the
`sandbox` and `policy` attributes, the following could all be used to create a
sandboxed iframe:

```html
<iframe sandbox>
<iframe sandbox="allow-scripts allow-forms">
<iframe policy="no-scripts"> (This is a non-sandboxed frame with no scripting allowed)
<iframe sandbox policy="scripts"> (Should this be allowed?)
<iframe sandbox="allow-scripts" policy="no-scripts"> (This one needs some work)
<iframe policy="no-same-origin"> (This is a frame with an opaque origin, but no other sandboxing)
```

None of these result in a `Sec-Required-Document-Policy` header, as all of the
existing sandbox features are safelisted.

However, new features are not safelisted, and so would result in a header if any
of them are restricted:

```html
<iframe policy="no-scripts, no-document-write">
```

results in a request header:

```http
Sec-Required-Document-Policy: no-document-write
```

(Note that `no-scripts` is not present in the header; only those values which
are required to appear in the response header are listed.)

The sandbox attribute in an iframe tag serves to disable all of the
currently-defined sandbox features. These can also be toggled individually with
the policy attribute:

```html
<iframe policy="no-document-write, no-escape-in-popups">
```

They can also be set from an HTTP header:

```http
Require-Document-Policy: no-forms
```

Would impose the sandboxed forms browsing context flag on all nested content.

### Sandboxing yourself

```http
Document-Policy: no-popups, no-modals, no-presentation-lock, no-forms,
                 no-pointer-lock
```

In this case (like in the first document policy example), the document may embed
other content without these restrictions.

You can also include both headers, to sandbox yourself as well as all nested
content:

```http
Document-Policy: no-popups, no-modals, no-presentation-lock, no-forms, no-pointer-lock
Require-Document-Policy: no-popups, no-modals, no-presentation-lock, no-forms, no-pointer-lock
```

## So, how does it work?

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

Some policies are boolean switches, and can be turned off with the syntax
"`no-<feature-name>`":

* `no-popups`
* `no-scripts`
* `no-document-write`

Others take parameters, whose types and names are specific to each policy:

* `image-compression;min-bpp=2`
* `frame-loading;lazy`

All of the directives can be combined with commas into a single header. In
Structured-header-speak, this is a parameterized list.

### Requiring a policy in your embedded content

It is possible to enforce that content you embed conforms to a specific policy
as well. This can be done in two ways: either through a different response
header (`Require-Document-Policy`), which affects every iframe on your page; or
by using a "`policy`" attribute on specific frames, which target just those
frames.

`Require-Document-Policy` doesn't affect the document that it is returned with,
just the content that it embeds. It can be used in conjunction with the
`Document-Policy` header, though.

When you set a required document policy, most features will have to be
acknowledged by the document being embedded, as otherwise it can be possible to
affect the content on that page in unexpected ways. Any policies which require
acknowledgement will be advertised with a `Sec-Required-Document-Policy` request
header.

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
can be extended to cover the entire document policy. This flag itself, as a
sandbox flag, can be controlled independently as well.

### More Details: Opting in to being embedded with a policy

Each feature has an associated flag, ***requires-acknowledgement***, which is
true for all of those features which would be unsafe to impose on nested content
without that content's approval (and is true by default if not explicitly
defined).

(Alternately, we can define a central safelist of features which do not require
acknowledgement; the decision comes down to whether that call is made by the
feature policy spec or the specs which define the individual features)

As a starting point for discussion, all existing sandbox flags would not require
acknowledgement, and all other document policies would.

In documents generated from `data:` URLs, and in iframe srcdoc documents, where
the parent document controls the content of the child explicitly, and there is
no HTTP network transfer, the acknowledgment will simply be implied.

There is also a ***required document policy*** associated with every browsing
context.

For an iframe, that required policy is the union<sup>[1](#fn1)</sup> of the
parent's required document policy, the parent's `Require-Document-Policy`
header, and the policy attribute of the containing iframe element.

All features in the required policy which require acknowledgement will be
advertised in a `Sec-Required-Document-Policy` request header.

Example:

```http
Sec-Required-Document-Policy:
     no-document-write,no-storage,image-compression;bpp=4
```

If the response does not have a document policy response header which conforms
to that request header, it will not be loaded. Instead, a network error will be
returned instead, similar to CSP.

Note: This does not mean strictly increasing strictness: the following would work:

* Top-doc contains `<iframe policy="image-compression;bpp=4">`
  * First nested doc uses header `image-compression;bpp=2` (okay)
    * Second nested doc uses header `image-compression;bpp=3` (looser, still okay)

A document's final policy is the union<sup>[1](#fn1)</sup> of its browsing
context's required policy and it's own header policy. (If it weren't for
non-opt-in-required policies, the union wouldn't be required; we could just use
the header policy as-is).

<a name="fn1">1</a>: Note that "union" isn't exactly the right word for the
combination operation used here; it's something of a "strictest union", where we
take the strictest value from both sides, independently for each feature. This
should be spelled more explicitly still, in a proper spec.
