#  Image Policies Explainer

loonybear@, last updated: 10/30/2018

<span style="color:#38761d;">Status: in [Origin Trials](https://github.com/GoogleChrome/OriginTrials) in M75</span>


## Goal

Images make up majority of the downloaded bytes on websites. In addition, images often occupy a significant amount of visual space. Optimizing images can improve loading performance and reduce network traffic. Surprisingly, more than half of the sites on the web, including advanced ones, are shipping unoptimized images. This means these sites can all achieve a performance improvement by serving optimized images.

Optimized image policies are aiming to solve problems with sites shipping images that are poorly compressed or unnecessarily large.


## What are "Optimized Image Policies"?

Optimized image policies introduce a set of restrictions (policies) on images that can be applied with dev-time enforcement. An image will be rendered as a **placeholder image** when violating a policy, making it easy for web developers to identify and fix the error.


### Optimized image policies

*   **["oversized-images" policy](#oversized-images)**
    *   The intrinsic dimensions of HTMLImageElement must not be larger than the container size by more than _***X times***_ .
*   **["unoptimized-*-images" policy](#unoptimized-images)**
    *   Images used in rendering must not include too much metadata.
    *   Images should be in one of the modern image formats that yield large byte savings and performance improvement.
    *   **"unoptimized-lossy-images"**
        *   A lossy type HTMLImageElement should not exceed a byte-per-pixel ratio _***X***_, with a fixed _**1KB**_ overhead allowrance.
    *   **"unoptimized-lossless-images"**
        *   A lossless type HTMLImageElement should not exceed a byte-per-pixel ratio _***X***_, with a fixed _**1KB**_ overhead allowrance.
    *   **"unoptimized-lossless-images-10k"**
        *   A lossless type HTMLImageElement should not exceed a byte-per-pixel ratio _***X***_, with a fixed _**10KB**_ overhead allowrance.

**Note**: We want to allow developers the ability to make the final decision about the tradeoffs they make. _***X***_ means developers can specify the "value" of the policy. For example, `oversized-images *(2)` specifies the maximum ratio (2) images are allowed to be downscaled by.


## Experiment image policies with Origin Trials
You can request a token for your origin to opt any page on your origin into the trail of ["oversized-images" policy](https://developers.chrome.com/origintrials/#/trials/active), ["unoptimized-lossy-images"](https://developers.chrome.com/origintrials/#/trials/active), ["unoptimized-lossless-images"](https://developers.chrome.com/origintrials/#/trials/active), ["unoptimized-lossless-images-10k"](https://developers.chrome.com/origintrials/#/trials/active).

Once you have a token, you can provide the token on any pages in your origin using an `Origin-Trial` HTTP header:
```
Origin-Trial: **token as provided in the developer console**
```

Please see sessions below on how to specify an image policy via HTTP header `Feature-Poliy` header. 

For more details, see [Origin Trials Guide for Web Developers](https://github.com/GoogleChrome/OriginTrials/blob/gh-pages/developer-guide.md).


## Detailed policy discussion

<a name="oversized-images">
   
### "oversized-images" policy

</a>

On a web page, the number of pixels of a container determines the resolution of an image served inside. It is unnecessary to use an image that is much larger than what the viewing device can actually render; for example, serving a desktop image to mobile contexts, or serving an image intended for high-pixel-density screens to a low-pixel-density device. This results in unnecessary network traffic and downloaded bytes. `oversized-images` is a policy controlled feature that restricts images to be no more than X times bigger than the container size.

When a document is disallowed to use `oversized-images` policy, its `<img>` elements that are more than X times larger than the container size will be rendered as a placeholder image.


#### Specification

- The default allowlist for `oversized-images` is `*(max_limit)`. This means for pages of all origins,
`<img>` elements will be allowed and rendered correctly.

- An `oversized-images` policy can be specified via:

    **1. [HTTP `Feature-Policy`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy) response header:**
    ```html
    Feature-Policy: oversized-images *(0);
    ```
    In this example, `oversized-images` is **disabled for all frames** including the main frame. **All `<img>` elements will be rendered as placeholder images** as their intrinsic dimensions will be more than 0 (0 times larger than the container size).

    **2. [`allow` attribute in <iframe>](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#Attributes):**
    ```html
    <iframe src="https://example.com" allow="oversized-images 'self'(2) https://foo.com(3);">
    ```
    In this example, `oversized-images` is **disabled everywhere except on the origin of the main document and on `https://foo.com`**. On the origin of the main document, any `<img>` element whose intrinsic dimensions are **more than _2_ times** larger than the container size will be **rendered as a placeholder image**. On 'https://foo.com', any `<img>` element whose intrinsic dimensions are **more than _3_ times** larger than the container size will be **rendered as a placeholder image**. **`<img>` elements on any other origins will be rendered as placeholder images**.
       
    ```html
    <iframe allow="oversized-images *(4) 'self'(3)"></iframe>
    ```
    In this example, **the maximum oversizing ratio allowed is set to 4 except on the origin of the main document it is set to 3**. On the origin of the main document, any `<img>` element whose intrinsic dimensions are **more than _4_ times** larger than the container size will be **rendered as a placeholder image**. On other origins, any `<img>` element whose intrinsic dimensions are **more than _3_ times** larger than the container size will be **rendered as a placeholder image**.

- The recomnended oversizing ratio is **2**.
 

    Feature policies combine in subframes, and the minimum value of the downscaling ratio will be applied, so if that frame with the maximum oversizing ratio allowed set to 4 embedded another, which the syntax:

    ```html
    <iframe allow="oversized-images *(5)"></iframe>
    ```
    then the child frame would be allowed to render images with maximum oversizing ratio of **4**.

    If that frame embedded another child frame of the syntax:

    ```html
    <iframe allow="oversized-images *(3)"></iframe>
    ```
    then the other child frame would be allowed to render images with maximum oversizing ratio of **3**.


#### Examples

<table>
  <tr align="center">
   <td width="400">Feature-Policy: oversized-images *(2);</td>
   <td width="400">Default behavior</td>
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

For an `<img>` element, if neither the intrinsic width or the intrinsic height of the source image exceeds the number of pixels allowed by the policy in the container (2 times larger than the container's width or height), the image will be rendered correctly; if both the width and the height of the source image exceed the limit, the image will be rendered as a placeholder image.


<table>
  <tr align="center">
   <td width="400">Feature-Policy: oversized-images *(2);</td>
   <td width="400">Default behavior</td>
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

For an `<img>` element, if neither the intrinsic width or the intrinsic height of the source image exceeds the number of pixels allowed by the policy in the container (2 times larger than the container's width or height), the image will be rendered correctly; if the intrinsic width the source image exceeds the limit, the image will be rendered as a placeholder image.


<table>
  <tr align="center">
   <td width="400">Feature-Policy: oversized-images *(2);</td>
   <td width="400">Default behavior</td>
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

For an `<img>` element, if neither the intrinsic width or the intrinsic height of the source image exceeds the number of pixels allowed by the policy in the container (2 times larger than the container's width or height), the image will be rendered correctly; if the intrinsic height the source image exceeds the limit, the image will be rendered as a placeholder image
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
<iframe allow="unoptimized-images(image/bmp(1024, 0.5), image/jpeg(2048, 0.2))"></iframe>
```
Note: any otherwise unspecified MIME types will be using the default values. 


