# Unsized Media Policy Explainer

loonybear@, last updated: 4/25/2018

<span style="color:#38761d;">Status: Draft Proposal</span>


## Goal

Layout instability is one of the existing problems that are aggravating web experiences. For example, when the size of an `<img>` element is unspecified, it will cause the content around the `<img>` element to jump around. This is because the renderer does not know how much space to reserve for an image until the image is loaded, and once the image size is known the renderer will have to re-layout everything, causing the content to shift on the web page.

Unsized media policy is aiming to fix the problem by requiring all media elements to provide a size; if they don't, a default will be chosen, so that the image doesn't change size after loading.


## What is "unsized-media"?

`unsized-media` is a policy-controlled feature. It restricts images to have specified sizes. When a document is disallowed to use `unsized-media`, its `<img>`, `<video>`, and `<svg:image>` elements will be adopting a default size (300px X 150px) unless specified dimension(s) is(are) provided. 


### Specification

- The default allowlist for `unsized-media` is `*`. In other words, `unsized-media` is enabled for all origins by default. This means for pages of all origins, `<img>`, `<video>`, and `<svg:image>` elements will be rendered by their intrinsic sizes if unspecified.

- An `unsized-media` policy can be specified via:

    **1.  HTTP "Feature-Policy" response header**
    ```html
    Feature-Policy: unsized-media 'none';
    ```
    In this example, `unsized-media` is disabled for all frames including the main frame. All "media" elements will be using a default size (300px X 150px) for unspecified dimensions.

    **2. "allow" attribute in <iframe>**
    ```html
    <iframe src="https://example.com" allow="unsized-media 'self' https://foo.com;">
    ```
    In this example, `unsized-media` is disabled everywhere except on the origin of the main document and on `https://foo.com`.


### Examples

<table>
  <tr align="center">
   <td width="400">Feature-Policy: unsized-media 'none'; </td>
   <td width="400">Feature-Policy: unsized-media *; </td>
  </tr>
  <tr align="center">
   <td>
<img src="unsized-media-exmple0.png" width="80%">
   </td>
   <td>
<img src="unsized-media-exmple0.png" width="80%">
   </td>
  </tr>
  <tr align="center">
   <td colspan="2">

```html
"example0.com"
<img width="300" height="200" src="cat.jpg">
<img style="width:300px; height:200px" src="cat.jpg">
```
   </td>
  </tr>
</table>

For an `<img>`, `<video>`, or `<svg:image>` element, if its size is specified, then the element will be rendered using its specified size, regardless of the state of the policy.


<table>
  <tr align="center">
   <td width="400">Feature-Policy: unsized-media 'none'; </td>
   <td width="400">Feature-Policy: unsized-media *; </td>
  </tr>
  <tr align="center">
   <td>
<img src="resources/unsized-media-disabled1.png" width="80%">
   </td>
   <td>
<img src="resources/unsized-media-enabled1.png" width="80%">
   </td>
  </tr>
  <tr align="center">
   <td colspan="2">

```html
"example1.com"
<img width="300" src="cat.jpg">
<img style="height:300px;" src="cat.jpg">
```
   </td>
  </tr>
</table>

For an `<img>`, `<video>`, or `<svg:image>` element, if one dimension is specified, default width or height will be used, when `unsized-media` is disallowed.


<table>
  <tr align="center">
   <td width="400">Feature-Policy: unsized-media 'none'; </td>
   <td width="400">Feature-Policy: unsized-media *; </td>
  </tr>
  <tr align="center">
   <td>
<img src="resources/unsized-media-disabled2.png" width="80%">
   </td>
   <td>
<img src="resources/unsized-media-enabled2.png" width="80%">
   </td>
  </tr>
  <tr align="center">
   <td colspan="2">

```html
"example2.com"
<img src="cat.jpg">
```
   </td>
  </tr>
</table>

For an `<img>`, `<video>`, or `<svg:image>` element, if both dimensions are unspecified, default dimensions will be used, when `unsized-media` is disallowed.


## intrinsicsize="" Attribute on Media Elements

The caveat of the policy is that it is challenging to maintain an aspect ratio of a media element when the width is set to be proportional to the screen. One potential solution is to introduce an intrisicsize="" attribute on media elements. Please read the explainer for [Transfer Size Policy](https://github.com/ojanvafai/intrinsicsize-attribute) for more details.

