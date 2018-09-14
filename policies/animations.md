Allow Layout Animations Policy
===========

The 'layout-animations' policy-controlled feature can be used in a document or frame to
restrict the set of CSS properties which can be animated. This feature is proposed to 
ensure certain types of animations which *may* lead to layout and potentially heavy CPU
load are blocked.

What does that mean?
------------

In order to produce animations on the web, developers declare transitions of style
in either CSS (e.g., `@keyframes` and `animation`) or JavaScript (e.g., `element.animate()`). 
In principal, these transitions can be used to animate just about any CSS property (
backgrounds, sizes, margins, fonts, borders, positions amongst many other).

In order to support such animations, the browser has to constantly update the values for
all of these properties, and then calculate all their effects on the page; ideally, this has
to has to be done sixty times per second.

When properties such as `size` or `position` are changed in an animation, many other 
elements on the page to have to be moved around constantly (*layout and re-layout*), and 
browsers can struggle to keep up. When that happens, the result is a potentially stuttering
animation and a poorly performing and non-responsive web page; sometimes even the entire page
slows down, as the animation consumes all available CPU cycles.

To avoid this scenario developers should use animations carefully and limit the usage to
the animations which are not CPU intensive. One approach to motivate this practice is to
limit the usage of animations that *can* cause expensive CPU work - such as *layout* --
on the page. This can be done by blocking layout-inducing animations.

How is an animation blocked?
------------

Blocking an animation should be as non-intrusive as possible to avoid breaking current
web pages that rely on animations. Essentially, when an animations is blocked it should
still:
  - Fire all the animation related events (`animationstart`, `animationinterval`, `animationend`),
  - `transitionend` should fire as expected,
  - The intial and final style state should be respected.
  
Some CSS properties are interpolable -- that is, there is a way for the
browser to calculate a smooth transition from one value to another. This applies
to most properties that have numeric values (lengths, sizes, etc.) as well as
things like colors, paths and matrices.


When properties are not interpolable -- there is no such thing as an
intermediate state -- and such properties are "animated" by simply jumping
from the initial to the final value at some point during the animation.

The proposed method for blocking animations is the same: the animation involves a
single jump at the midpoint of the animation interval.

A potential solution: `layout-animations` policy-controlled feature
------------

With 'layout-animations' feature, developers are equipped with a switch to
disable animations that *can* cause expensive layout work. This involves properties
such as `top`, `width`, `max-height`, etc.

With that feature available, a page could declare that it only uses animations that
do not lead to layout, by delivering an HTTP header like this:

```http
Feature-Policy: layout-animations 'none'
```

or it could do the same for a particular `iframe` element in the page:

```html
<iframe allow="layout-animations 'none'" src="..."></iframe>
```
If a particular site needs to use all style properties for animations, 
then it can be granted the ability to do that, while still blocking
animations from other sites:

```html
<iframe allow="layout-animations https://anim8.example.com" src="..."></iframe>
```

Future work based on `layout-animations`:
------------

To allow browsers room to innovate in this space, and grant developers the ability
to make the final decision about the tradeoffs in their choice of enabled animations,
a generic more syntactic `animation` feauture can be proposed based on list values.
The developers can then choose the set of properties that should be allowed to run
on their site.

In practice, that would look something like this:

```html
<iframe allow="animations(transform,opacity,border-color)"></iframe>
```

That would apply a policy in which just those three properties can be animated
(as well as any sub-properties, such as `border-top-color`). 

Feature policies combine in subframes, so if that frame embedded another, with
the syntax:

```html
<iframe allow="animations(transform,margin)"></iframe>
```
then the child frame would be allowed to animate just the `transform` property.

First Steps in Implementing the Feautre
-------------
As mentioned above, the policy will affect animated properties that cause layout; the actual list of such properties might be long and should be extracted from [CSS spec](https://drafts.csswg.org/). To implement a *first version of the policy*, the following  animations should be included in `layout-animations`:
```
bottom, height, left, right, top, width
```
These properties are used quite often and on Chrome, they contribute to [almost](https://www.chromestatus.com/metrics/css/animated) 11.7% of total animation use cases. From the same data it can be inferred that (ignoring some non-layout and irrelevant properties such as `transform`, `visibility`, etc.), the overal share of such animations is as high as 34%; hence the justification for inclusion of these properties in the v1 of the policy.
