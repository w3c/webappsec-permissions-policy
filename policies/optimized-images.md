# Bonsai Web -- Optimized Image Policies Explainer

loonybear@, last updated: 4/25/2018

<span style="color:#38761d;">Status: Draft Proposal</span>


## Goal

Images make up majority of the downloaded bytes on websites. In addition, images often occupy a significant amount of visual space. Optimizing images can improve loading performance and reduce network traffic. Surprisingly, more than half of the sites on the web, including advanced ones, are shipping unoptimized images. This means these sites can all achieve a performance improvement by serving optimized images.

 

Optimized image policies are aiming to solve problems with sites shipping images that are poorly compressed or unnecessarily large.


## What are "Optimized Image Policies"?

"Optimized Image Policies" introduce a set of restrictions (policies) on images that can be applied with dev-time enforcement. An image will be rendered with **inverted colors** when violating a policy, making it easy for web developers to identify and fix the error. 


### Optimized image policies

*   **["legacy-image-formats" policy](#legacy-image-formats)** 
    *   Images must be of one of the _**modern formats***_ (JPEG, PNG, WEBP, etc).
*   **["maximum-downscaling-image" policy](#maximum-downscaling-image)**
    *   Images must not be bigger than its container size by more than _**X times***_ . 
*   **["image-compression" policy](#image-compression)**
    *   Images used in rendering must not include too much metadata. 
    *   Images must not be more than _**X bits***_ per compressed pixel. 

**Note**: * means developers will eventrually be able to specify the "value" of the policy. For example, `maximum-downscaling-image(2)` specifies the maximum ratio (2) images are allowed to be downscaled by. 


## Detailed policy discussion

<a name="legacy-image-formats">
### "legacy-image-formats" policy
</a>

Image formats affect file size, loading speed and appearance. Modern image formats yield large byte savings and performance improvement. `legacy-image-formats` is a policy controlled feature that restricts images to be one of certain modern formats.

When a document is disallowed to use `legacy-image-formats` policy, its `<img>` elements will render images of "legacy" formats with inverted colors. 


#### Specification

The default list of modern image formats is: JPEG, PNG, GIF, WEBP, and SVG. 

---

**Note**: We want to allow developers the ability to make the final decision about the tradeoffs they make. The goal is to eventually introduce a syntax for specifying which modern formats can be allowed. The developer can choose this minimum set (default list), or can add additional formats which they either know can be rendered fast, or just need for their site. 

In practice, they would look something like this:

```html
<iframe allow="legacy-image-formats(JPEG, PNG, TIFF)"></iframe>
```

That would apply a policy in which just those three formats can be allowed. 

Feature policies combine in subframes, so if that frame embedded another, which
the syntax:

```html
<iframe allow="legacy-image-formats(JPEG, GIF, BMP)"></iframe>
```

then the child frame would be allowed to render images of just "JPEG" format.

---

The default allowlist for `legacy-image-formats` is *. This means for pages of all origins, `<img>` elements with "legacy" formats will be allowed and rendered correctly by default.

A `legacy-image-formats` policy can be specified via:

1. **HTTP "Feature-Policy" response header**:
```html
Feature-Policy: legacy-image-formats 'none'; <more policies>
```

In this example, `legacy-image-formats` is disabled for all frames including the main frame. All `<img>` elements with "legacy" formats will be rendered with inverted colors.

2. **"allow" attribute in <iframe>**:
```html
<iframe src="https://example.com" allow="legacy-image-formats 'self' https://foo.com;">
```

In this example, `legacy-image-formats` is disabled everywhere except on the origin of the main document and on `https://foo.com`.


#### Example

<table>
  <tr>
   <td><code>Feature-Policy: legacy-image-formats 'none';</code>
   </td>
   <td><code>Feature-Policy: legacy-image-formats *;</code>
   </td>
  </tr>
  <tr>
   <td>

<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!-- <img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing"> -->

   </td>
   <td>

<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!-- <img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing"> -->

   </td>
  </tr>
  <tr>
   <td colspan="2" ><code>example.com</code>
<p>
<code><img id="modern-formats" <strong>src="test.png"</strong>></code>
<code><img id="legacy-formats" <strong>src="test.bmp"</strong>></code>
   </td>
  </tr>
</table>


For an <img> element, if its src is one of the modern image formats, the image will be rendered correctly; otherwise the image will be rendered with inverted colors.


### "maximum-downscaling-image" policy

On a web page, the number of pixels of a container determines the resolution of an image served inside. It is unnecessary to use an image that is much larger than what the viewing device can actually render; for example, serving a desktop image to mobile contexts, or serving an image intended for high-pixel-density screens to a low-pixel-density device. This results in unnecessary network traffic and downloaded bytes. "maximum-downscaling-image" is a [policy controlled](https://docs.google.com/document/d/1k0Ua-ZWlM_PsFCFdLMa8kaVTo32PeNZ4G7FFHqpFx4E/edit) feature that restricts images to be no more than X times bigger than the container size. 

When a document is disallowed to use "maximum-downscaling-image" policy, its <img> elements that are more than X times larger than its container size will be rendered with inverted colors. 


#### Specification

The default downscaling ratio is 2. 

Note: with support of "list values", web developers will be able to specify their own ratio.

The default allowlist for "maximum-downscaling-image" is *. This means for pages of all origins, <img> elements that are more than X times larger than its container size will be allowed and rendered correctly.

A "maximum-downscaling-image" policy can be specified via: \




1.  **HTTP "Feature-Policy" response header** \
`Feature-Policy: maximum-downscaling-image 'none'; <more policies> ` \
 \
In this example, "maximum-downscaling-image" is disabled for all frames including the main frame. All <img> elements that are more than X times larger than its container size will be rendered with inverted colors.
1.  **"allow" attribute in <iframe>** \
`<iframe src="https://example.com" allow="maximum-downscaling-image 'self' https://foo.com;"> \
 \
`In this example, "maximum-downscaling-image" is disabled everywhere except on the origin of the main document and on "https://foo.com".  


#### 


#### Examples


<table>
  <tr>
   <td><code>Feature-Policy: maximum-downscaling-image 'none';</code>
   </td>
   <td><code>Feature-Policy: maximum-downscaling-image *;</code>
   </td>
  </tr>
  <tr>
   <td>

<p id="gdcalert3" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert4">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
   <td>

<p id="gdcalert4" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert5">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
  </tr>
  <tr>
   <td colspan="2" ><code>example0.com</code>
<p>
<code>test.png: 150px X 150px </code>
<p>
<code><img id="within-range" width="100" height="100" src="test.png"></code>
<p>
<code><img id="over-width-and-height" width="50" height="50" src="test.png"></code>
   </td>
  </tr>
</table>


For an <img> element, if neither the width or the height of the source image exceeds the number of pixels allowed by the policy in the container (by default, 2 times of its container's width of height), the image will be rendered correctly;  if both the width and the height of the source image exceed the limit, the image will be rendered with inverted colors.


<table>
  <tr>
   <td><code>Feature-Policy: maximum-downscaling-image 'none';</code>
   </td>
   <td><code>Feature-Policy: maximum-downscaling-image *;</code>
   </td>
  </tr>
  <tr>
   <td>

<p id="gdcalert5" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert6">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
   <td>

<p id="gdcalert6" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert7">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
  </tr>
  <tr>
   <td colspan="2" ><code>example1.com</code>
<p>
<code>test.png: 150px X 150px </code>
<p>
<code><img id="within-range" width="100" height="100" src="test.png"></code>
<p>
<code><img id="over-height" width="100" height="50" src="test.png"></code>
   </td>
  </tr>
</table>


For an <img> element, if neither the width or the height of the source image exceeds the number of pixels allowed by the policy in the container (by default, 2 times of its container's width or height), the image will be rendered correctly; if the width the source image exceeds the limit, the image will be rendered with inverted colors.


<table>
  <tr>
   <td><code>Feature-Policy: maximum-downscaling-image 'none';</code>
   </td>
   <td><code>Feature-Policy: maximum-downscaling-image *;</code>
   </td>
  </tr>
  <tr>
   <td>

<p id="gdcalert7" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert8">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
   <td>

<p id="gdcalert8" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert9">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
  </tr>
  <tr>
   <td colspan="2" ><code>example2.com</code>
<p>
<code>test.png: 150px X 150px </code>
<p>
<code><img id="within-range" width="100" height="100" src="test.png"></code>
<p>
<code><img id="over-width" width="50" height="100" src="test.png"></code>
   </td>
  </tr>
</table>


For an <img> element, if neither the width or the height of the source image exceeds the number of pixels allowed by the policy in the container (by default, 2 times of its container's width or height), the image will be rendered correctly; if the height the source image exceeds the limit, the image will be rendered with inverted colors.


### "image-compression" policy

When optimizing images, the file size should be kept as small as possible. The larger the download size is, the longer it takes a page to load. Stripping metadata, or using image compression, is a common way to optimize an image's file size. "image-compression" is a [policy controlled](https://docs.google.com/document/d/1k0Ua-ZWlM_PsFCFdLMa8kaVTo32PeNZ4G7FFHqpFx4E/edit) feature that restricts images to have a file size (in terms of number of bytes) no more than X times bigger than the image size (width * height) on the web page.

When a document is disallowed to use "image-compression" policy, its <img> elements whose file sizes are too big will be rendered with inverted colors. 


#### Specification

The default compression ratio is tentatively 10. 

Note: with support of "list values", web developers will be able to specify their own ratio.

The default allowlist for "image-compression" is *. This means for pages of all origins, <img> elements whose file sizes exceeds the compression ratio will be allowed and rendered correctly.

A "image-compression" policy can be specified via: \




1.  **HTTP "Feature-Policy" response header** \
`Feature-Policy: image-compression 'none'; <more policies> ` \
 \
In this example, "image-compression" is disabled for all frames including the main frame. All <img> elements whose file sizes exceeds the compression ratio will be rendered with inverted colors.
1.  **"allow" attribute in <iframe>** \
`<iframe src="https://example.com" allow="image-compression 'self' https://foo.com;"> \
 \
`In this example, "image-compression" is disabled everywhere except on the origin of the main document and on "https://foo.com".  


#### 


#### Examples


<table>
  <tr>
   <td><code>Feature-Policy: image-compression 'none';</code>
   </td>
   <td><code>Feature-Policy: image-compression *;</code>
   </td>
  </tr>
  <tr>
   <td>

<p id="gdcalert9" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert10">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
   <td>

<p id="gdcalert10" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href=http://go/g3doc-drawings>go/g3doc-drawings</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert11">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


<!--<img src="https://docs.google.com/a/google.com/drawings/d/12345/export/png" width="80%" alt="drawing">-->

   </td>
  </tr>
  <tr>
   <td colspan="2" ><code>example.com</code>
<p>
<code><img id="normal-size" src="test.png"></code>
<p>
<code><img id="oversized" src="test-oversized.png"></code>
   </td>
  </tr>
</table>


For an <img> element, if its file size is within the compression limit, the image will be rendered correctly; otherwise the image will be rendered with inverted colors.

