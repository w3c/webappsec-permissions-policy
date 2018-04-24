Allowed Animations Policy
===========

The 'animations' policy-controlled feature can be used in a document or frame to
restrict the set of CSS properties which can be animated. This can ensure smooth
animations, by only allowing those properties which can be animated on the GPU,
using the hardware compositor.

What does that mean?
------------

In order to produce animations on the web, developers declare transitions inside
of CSS. These transitions can be used to animate just about any CSS property --
backgrounds, sizes, margins, fonts, borders, positions -- there's almost no
limit. In order to make this happen, the browser has to update the values for
all of these properties, and then calculate all of the other effects that has on
the page, and it has to update the page like this every frame, sixty times per
second.

If the properties being animated are changing size or position, this can easily
cause many other items on the page to have to be moved around constantly, and
browsers can struggle to keep up. When that happens, the result is a stuttering
animation and a poorly performing web page, and sometimes even the entire slows
down, as the animation consumes all available CPU cycles.

One way to avoid this scenario is to move the animations off of the CPU
entirely. Modern desktop computers and mobile devices have powerful GPUs that
can perform certain kinds of animations much more efficiently, and can leave the
CPU free to handle other things, like responding to user input.

Deeper explanation
------------

Many (most?) CSS properties are interpolable -- that is, there is a way for the
browser to calculate a smooth transition from one value to another. This applies
to most properties that have numeric values (lengths, sizes, etc.) as well as
things like colors, paths and matrices.

Other properties are not interpolable -- there is no such thing as an
intermediate state -- `font-face`, for instance, or `background-image`. These
properties are "animated" by simply jumping from the initial to the final value
at the midpoint of the animation.

A potential solution
------------

We could define an 'animations' feature to provide a switch for developers to
disable animations that can't be moved to the GPU. It would do this by
redefining *all* properties, except for `opacity`, `transform` and `filter`, to
be non-interpolable, in any document where the feature is disabled.

With that feature available, a page could declare that it only uses
GPU-composited animations by delivering an HTTP header like this:

```http
Feature-Policy: animations 'none'
```

or it could do the same for a particular `iframe` element in the page:

```html
<iframe allow="animations 'none'" src="..."></iframe>
```
If you know that a particular site needs to be allowed to animate non-composited
properties, then it can be granted the ability to do that, while blocking
animations from other sites:

```html
<iframe allow="animations https://anim8.example.com" src="..."></iframe>
```

Problems with this, and a better solution
------------

Currently, `transform`, `opacity` and `filter` are the only properties which can
be universally composited on the GPU, and so we're using that as the initial
set. However, we want to allow browsers room to innovate in this space, and we
want to allow developers the ability to make the final decision about the
tradeoffs they make. The browser (especially a single browser) shouldn't have
the only voice. To allow that, the goal is to eventually introduce a syntax for
specifying which properties can be animated. The developer can choose this
minimum set, or can add additional properties which they either know can be
animated smoothly, or just need for their site.

In practice, that would look something like this:

```html
<iframe allow="animations(transform,opacity,border-color)"></iframe>
```

That would apply a policy in which just those three properties can be animated
(as well as any sub-properties, such as `border-top-color`, for instance.) At
this time, no browsers animate `border-color` on the GPU, and so the CPU will
have to do additional work in this case, but it will be allowed.

Feature policies combine in subframes, so if that frame embedded another, with
the syntax:

```html
<iframe allow="animations(transform,margin)"></iframe>
```
then the child frame would be allowed to animate just the `transform` property.
