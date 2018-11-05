#  Image Policies Explainer

loonybear@, last updated: 10/30/2018

<span style="color:#38761d;">Status: Draft Proposal</span>


## Goal

Images make up majority of the downloaded bytes on websites. In addition, images often occupy a significant amount of visual space. Optimizing images can improve loading performance and reduce network traffic. Surprisingly, more than half of the sites on the web, including advanced ones, are shipping unoptimized images. This means these sites can all achieve a performance improvement by serving optimized images.

Optimized image policies are aiming to solve problems with sites shipping images that are poorly compressed or unnecessarily large.


## What are "Optimized Image Policies"?

Optimized image policies introduce a set of restrictions (policies) on images that can be applied with dev-time enforcement. An image will be rendered as a **placeholder image** when violating a policy, making it easy for web developers to identify and fix the error.


### Optimized image policies

*   **["oversized-images" policy](#oversized-images)**
    *   Images must not be bigger than its container size by more than _***X times***_ .
*   **["unoptimized-images" policy](#unoptimized-images)**
    *   Images used in rendering must not include too much metadata.
    *   Images must not be more than _***X bits***_ per compressed pixel.
    *   Images should be in one of the modern image formats that yield large byte savings and performance improvement.

**Note**: We want to allow developers the ability to make the final decision about the tradeoffs they make. * means developers will eventrually be able to specify the "value" of the policy. For example, `oversized-images(2)` specifies the maximum ratio (2) images are allowed to be downscaled by.


## Detailed policy discussion

<a name="oversized-images">
   
### "oversized-images" policy

</a>

On a web page, the number of pixels of a container determines the resolution of an image served inside. It is unnecessary to use an image that is much larger than what the viewing device can actually render; for example, serving a desktop image to mobile contexts, or serving an image intended for high-pixel-density screens to a low-pixel-density device. This results in unnecessary network traffic and downloaded bytes. `oversized-images` is a policy controlled feature that restricts images to be no more than X times bigger than the container size.

When a document is disallowed to use `oversized-images` policy, its `<img>` elements that are more than X times larger than its container size will be rendered as a placeholder image.


#### Specification

- The default oversizing ratio is 2.

    **Note**: The goal is to eventually introduce a syntax for specifying the maxmimum oversizing ratio to be allowed.

    In practice, they would look something like this:

    ```html
    <iframe allow="oversized-images(4)"></iframe>
    ```
    That would apply a policy in which the maximum oversizing ratio allowed is set to 4.

    Feature policies combine in subframes, and the minimum value of the downscaling ratio will be applied, so if that frame embedded another, which the syntax:

    ```html
    <iframe allow="oversized-images(5)"></iframe>
    ```
    then the child frame would be allowed to render images with maximum oversizing ratio of 4.

    If that frame embedded another child frame of the syntax:

    ```html
    <iframe allow="oversized-images(3)"></iframe>
    ```
    then the other child frame would be allowed to render images with maximum oversizing ratio of 3.

- The default allowlist for `oversized-images` is `*`. This means for pages of all origins,
`<img>` elements that are more than X times larger than its container size will be allowed and rendered correctly.

- A `oversized-images` policy can be specified via:

    **1. HTTP "feature-policy" response header:**
    ```html
    Feature-Policy: oversized-images 'none';
    ```
    In this example, `oversized-images` is disabled for all frames including the main frame. All `<img>` elements that are more than X times larger than its container size will be rendered as placeholder images.

    **2. "allow" attribute in <iframe>:**
    ```html
    <iframe src="https://example.com" allow="oversized-images 'self' https://foo.com;">
    ```
    In this example, "oversized-images" is disabled everywhere except on the origin of the main document and on `https://foo.com`.


#### Examples

<table>
  <tr align="center">
   <td width="400">Feature-Policy: oversized-images 'none';</td>
   <td width="400">Feature-Policy: oversized-images *;</td>
  </tr>
  <tr align="center">
   <td>
<img src="resources/max-ds-img-disabled1.png" width="80%">
   </td>
   <td>
<img src="resources/max-ds-img-enabled1.png" width="80%">
   </td>
  </tr>
</table>

For an `<img>` element, if neither the width or the height of the source image exceeds the number of pixels allowed by the policy in the container (by default, 2 times of its container's width of height), the image will be rendered correctly;  if both the width and the height of the source image exceed the limit, the image will be rendered as a placeholder image.


<table>
  <tr align="center">
   <td width="400">Feature-Policy: oversized-images 'none';</td>
   <td width="400">Feature-Policy: oversized-images *;</td>
  </tr>
  <tr align="center">
   <td>
<img src="resources/max-ds-img-disabled0.png" width="80%">
   </td>
   <td>
<img src="resources/max-ds-img-enabled0.png" width="80%">
   </td>
  </tr>
</table>

For an `<img>` element, if neither the width or the height of the source image exceeds the number of pixels allowed by the policy in the container (by default, 2 times of its container's width or height), the image will be rendered correctly; if the width the source image exceeds the limit, the image will be rendered as a placeholder image.


<table>
  <tr align="center">
   <td width="400">Feature-Policy: oversized-images 'none';</td>
   <td width="400">Feature-Policy: oversized-images *;</td>
  </tr>
  <tr align="center">
   <td>
<img src="resources/max-ds-img-disabled2.png" width="80%">
   </td>
   <td>
<img src="resources/max-ds-img-enabled2.png" width="80%">
   </td>
  </tr>
</table>

For an `<img>` element, if neither the width or the height of the source image exceeds the number of pixels allowed by the policy in the container (by default, 2 times of its container's width or height), the image will be rendered correctly; if the height the source image exceeds the limit, the image will be rendered as a placeholder image.
</br></br>

<a name="unoptimized-images">

### "unoptimized-images" policy

</a>

When optimizing images, the file size should be kept as small as possible. The larger the download size is, the longer it takes a page to load. Stripping metadata, picking a good image format, and using image compression, are all common ways to optimize an image's file size. `unoptimized-images` is a policy controlled feature that restricts images to have a file size (in terms of number of bytes) no more than X times bigger than the image size (width * height) on the web page.

When a document is disallowed to use `unoptimized-images` policy, its `<img>` elements whose file sizes are too big will be rendered as placeholder images.


#### Specification
- The default maximum file size of an optimized image is calculated as following:
    
   ```metadata size limit + byte-per-pixel ratio * image resolution```
    + For images of one of the modern formates (JPEG, PNG, GIF, WEBP, and SVG)
        + The default metadata size limit is tentatively 1KB (1024 bytes).
        + The default byte-per-pixel ratio is tentatively 0.5.
    + For images of other legacy formats   
        + The metadata size limit is set to 0KB.
        + The byte-per-pixel ratio is set to 0.

    **Note**: We want to allow developers the ability to make the final decision about the tradeoffs they make. The goal is to eventually introduce a syntax for specifying their own parameters.

    In practice, they would look something like this:

    ```html
    <iframe allow="unoptimized-images(1500, 0.4)"></iframe>
    ```
    That would apply a policy in which the metadata size limit is set to 1500 bytes and the byte-per-pixel ratio is set to 0.4.  
   
    Feature policies combine in subframes, and the minimum value of the parameters will be applied, so if that frame embedded another, which the syntax:

    ```html
    <iframe allow="unoptimized-images(2048, 0.2)"></iframe>
    ```
    then the child frame would be allowed to render images with metadata size limit of 1500 bytes and byte-per-pixel ratio of 0.2. 

- The default allowlist for `unoptimized-images` is `*`. This means for pages of all origins, `<img>` elements whose file sizes exceeds the compression ratio will be allowed and rendered correctly.


- A `unoptimized-images` policy can be specified via:

    **1. HTTP "feature-policy" response header:**
    ```html
    Feature-Policy: unoptimized-images 'none';
    ```
    In this example, `unoptimized-images` is disabled for all frames including the main frame. All `<img>` elements whose file sizes exceeds the limit will be rendered as placeholder images.

    **2. "allow" attribute in <iframe>:**
    ```html
    <iframe src="https://example.com" allow="unoptimized-images 'self' https://foo.com;">
    ```
    In this example, `unoptimized-images` is disabled everywhere except on the origin of the main document and on `https://foo.com`.


#### Examples

<table>
  <tr align="center">
   <td width="400">Feature-Policy: unoptimized-images 'none'; </td>
   <td width="400">Feature-Policy: unoptimized-images *; </td>
  </tr>
  <tr align="center">
   <td>
 <img src="resources/unoptimized-disabled.png" width="80%"> 
   </td>
   <td>
 <img src="resources/unoptimized-enabled.png" width="80%"> 
   </td>
  </tr>
</table>

For an `<img>` element, if its file size is within the limit, the image will be rendered correctly; otherwise the image will be rendered as placeholder images.


**Future Development**

Image formats affect file size. We want to support different default values for different image formats.
We want to allow developers to specify the parameters as well. In practice, they would look something like this:
```html    
<iframe allow="unoptimized-images(image/bmp(1, 0.5), image/jpeg(2, 0.2), image/jpg(2, 0.2), img/jpg(2, 0.2))"></iframe>
```
Note: any otherwise unspecified MIME types will be using the default values. 


