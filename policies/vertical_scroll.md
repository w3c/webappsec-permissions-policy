# Vertical Scroll Policy
Vertical scroll policy is a feature introduced to assist websites in blocking
certain embedded contents from interfering with vertical scrolling. Stopping a user from vertically
scrolling the page might be a frustrating experience. This issue has been filed and tracked as a
[bug](https://crbug.com/611982) for Chromium for a while.

## Proposed Solution
The proposed solution is introducing a new feature, namely, `vertical-scroll` which gives the priviledge of potentially
interfering with user's scroll to a frame (the whole page or a subset of `<iframe>`s). This means if a certain `<iframe>`
does not have the feature enabled, it should not be able to interfere nor affect vertical scrolling in its embedder.

A page can declare the vertical scrolling feature in its HTTP headers as follows:
```http
Feature policy: vertical-scroll 'self'
```
which suggests only same-origin <iframe>'s are allowed to interfere with vertical scroll. Alternatively, the feature can
be declared for a single `<iframe>` using `allow` attribute:
```html
<iframe src="..." allow="vertical-scroll 'none'"></iframe>
```
which will limit the ability of the `<iframe>` in blocking vertical scrolling. Alternatively, specific origins can be
whitelisted to use the feature:
```html
<iframe src="..." allow="vertical-scroll https://www.example.com"></iframe>
```
In order to avoid breaking web pages, the feature should be enabled by default for all pages and `<iframe>`s, unless specified
otherwise in the HTTP header or `<iframe>`'s `allow` attribute.

## Proposed Implementation
There are several techniques that can be used by an `<iframe>` to block user's ability to scroll:
  * Canceling (calling `event.preventDefault()`) scroll related events such as `touchstart`, `touchmove`, or `wheel`.
  * Assigning a `touch-action` which prevents vertically scrolling, i.e., does not include `pan-y` or `pinch-zoom`.
  * (Ab)Using programmatic scrolling, i.e. `element.scrollIntoView()`.

The propsoed solution is that disabled frames (i.e., those with `vertical-scroll 'none'`) will not be able to use
either of the mentioned techniques. This is attained by:
  * Ensuring all scroll related input events are non-cancelable.
  * All elements and nodes inside such frames do have `pan-y` in their`touch-action` CSS property (if not, enforce `pan-y`).
  * Scripted and programmtic scorlling is handled within the scrop of a frame, i.e., calls to `element.scrollIntoView()`
  do not propagate outside of a disabled frame.
 
Furthermore, when `vertical-scroll` is disabled in a frame, no scrollable content should be able to consume scroll gestures
from the user. This would ensure that an embedded content cannot use techniques such as infinite scrolling to steal all the
scroll gestures on the page.
 
