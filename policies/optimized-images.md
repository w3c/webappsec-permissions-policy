#  Image Policies Explainer

loonybear@, last updated: 03/27/2019

<span style="color:#38761d;">Status: Draft Proposal
   
   Note that features are available in [Origin Trials](https://github.com/GoogleChrome/OriginTrials) in M75</span>


## Goal

Images make up majority of the downloaded bytes on websites. In addition, images often occupy a significant amount of visual space. Optimizing images can improve loading performance and reduce network traffic. Surprisingly, more than half of the sites on the web, including advanced ones, are shipping unoptimized images. This means these sites can all achieve a performance improvement by serving optimized images.

Optimized image policies are aiming to solve problems with sites shipping images that are poorly compressed or unnecessarily large.


## What are "Optimized Image Policies"?

Optimized image policies introduce a set of restrictions (policies) on images that can be applied with dev-time enforcement. An image will be replaced with a **placeholder image** when violating a policy, making it easy for web developers to identify and fix the error. In addition, violations can be observed via [Feature Policy Reporting](https://github.com/w3c/webappsec-feature-policy/blob/master/reporting.md). With HTTP header `Feature-Policy-Report-Only` (enabled via Feature Policy Reporting origin trial), image policies can be specified in "report-only" mode, which means images will render normally without enforcement, but policy violations will be reported, like [Content Security Policy](https://w3c.github.io/webappsec-csp/#cspro-header).


### Optimized image policies

*   **["oversized-images" policy](#oversized-images)**
    *   The intrinsic dimensions of `<img>` elements must not be larger than the container size by more than _***X times***_.
*   **["unoptimized-lossy-images" policy](#unoptimized-{lossy,lossless}-images)**
    *   Lossy images used in rendering must not include too much metadata.
    *   Lossy images should be in one of the modern image formats that yield large byte savings and performance improvement.
    *   A lossy `<img>` element should not exceed a byte-per-pixel ratio of _***X***_, with a fixed _**1KB**_ overhead allowance. For a W x H image, the file size threshold is calculated as `W x H x X + 1024` (where X is specified in the policy). Any image whose file size exeeds the limit will be blocked.
*   **["unoptimized-lossless-images" policy](#unoptimized-{lossy,lossless}-images)**
    *   Lossless images used in rendering must not include too much metadata.
    *   Lossless images should be in one of the modern image formats that yield large byte savings and performance improvement.
    *   A lossless `<img>` element should not exceed a byte-per-pixel ratio of _***X***_, with a fixed _**1KB**_ overhead allowance. For a W x H image, the file size threshold is calculated as `W x H x X + 1024` (where X is specified in the policy). Any image whose file size exeeds the limit will be blocked.
    
        **Note**: we are still trying to figure out the appropriate overhead allowance for the policies. We are experimenting with 2 features for lossless images: "unoptimized-lossless-images", where the overhead allowed is set to 10K, and "unoptimized-lossless-images-strict", where the overhead allowed is set to 1K.

**Note**: We want to allow developers the ability to make the final decision about the tradeoffs they make. _***X***_ means developers can specify the "value" of the policy. For example, `oversized-images *(2)` specifies the maximum ratio, 2, images are allowed to oversize by.


## Experiment image policies with Origin Trials

Image policies are shipped in Chrome M75 via Origin Trials.

Request a token to try the origin trial on your own origin:
   * Provide the token on any pages in your origin using an `Origin-Trial` HTTP header:
   ```
   Origin-Trial: **token as provided in the developer console**
   ```

   * Specify an image policy via HTTP header `Feature-Poliy` header (see below for more details). 
   ```
   Feature-Policy: **image policies specified here**
   ```

For more details, see [Origin Trials Guide for Web Developers](https://github.com/GoogleChrome/OriginTrials/blob/gh-pages/developer-guide.md).



## Detailed policy discussion

<a name="oversized-images">
   
### "oversized-images" policy

</a>

On a web page, the number of pixels of a container determines the resolution of an image served inside. It is unnecessary to use an image that is much larger than what the viewing device can actually render; for example, serving a desktop image to mobile contexts, or serving an image intended for high-pixel-density screens to a low-pixel-density device. This results in unnecessary network traffic and downloaded bytes. `oversized-images` is a policy controlled feature that restricts images to be no more than X times bigger than the container size.

When a document disallows the `oversized-images` policy, the `<img>` elements that are more than X times larger than the container size in either dimension will be replaced with placeholder images.

To try the `oversized-images` policy, register a token [here](https://developers.chrome.com/origintrials/#/trials/active) and specify the policy via HTTP `Feature-Policy` header (see section above for more details). Please note that origin trial token is Chrome-specific.


#### Specification

- The default allowlist for `oversized-images` is `*(inf)`. This means for pages of all origins,
all `<img>` elements will be allowed and rendered correctly by default.

- An `oversized-images` policy can be specified via:

    **1. [HTTP `Feature-Policy`]( https://w3c.github.io/webappsec-feature-policy/#feature-policy-http-header-field) response header:**
   ```html
    Feature-Policy: oversized-images *(0);
   ```
    In this example, `oversized-images` is **disabled for all frames** including the main frame. All `<img>` elements will be replaced with placeholder images as their intrinsic dimensions will be more than 0 (0 times larger than the container size in either dimension).
    
    **2. [`allow` attribute in <iframe>](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#Attributes):**
   ```html
   <iframe src="https://example.com" allow="oversized-images 'self'(2) https://foo.com(3);">
   ```
    In this example, `oversized-images` is **disabled everywhere except on the origin of the main document and on `https://foo.com`**. On the origin of the main document, any `<img>` element whose intrinsic dimensions are more than _2_ times larger than the container size in either dimension will be replaced with a placeholder image. On 'https://foo.com', any `<img>` element whose intrinsic dimensions are more than _3_ times larger than the container size in either dimension will be replaced with a placeholder image. **`<img>` elements on any other origins will be replaced with placeholder images**.

    ```html
    <iframe allow="oversized-images *(4) 'self'(3)"></iframe>
    ```
    In this example, **the maximum oversizing ratio allowed is set to 4 everywhere except on the origin of the main document where it is set to 3**. On the origin of the main document, any `<img>` element whose intrinsic dimensions are more than _4_ times larger than the container size in either dimension will be replaced with a placeholder image. On other origins, any `<img>` element whose intrinsic dimensions are more than _3_ times larger than the container size in either dimension will be replaced with a placeholder image.

- The recomnended oversizing ratio is **2**.

  **Note**: `oversized-images` takes a device's pixel ratio into account and compares the actual number of rendered pixels to the source image's intrinsic size.

  Use `srcset` to scale images on a higher resolution device.

- Feature policies combine in subframes, and the minimum value of the downscaling ratio will be applied. So if a frame whose maximum oversizing ration is set to 4, embed another using this syntax:

   ```html
   Feature-Policy: oversized-images *(4);
   ```
   ```html
   <iframe allow="oversized-images *(5)"></iframe>
   ```
   then the child frame would be allowed to render images with maximum oversizing ratio of **4**.   

   If that frame embedded another child frame of the syntax:

   ```html
   Feature-Policy: oversized-images *(4);
   ```
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

For an `<img>` element, if neither the intrinsic width nor the intrinsic height of the source image exceeds the number of pixels allowed by the policy in the container (2 times larger than the container's width or height), the image will be rendered correctly; if both the width and the height of the source image exceed the limit, a placeholder image will be rendered instead.


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

For an `<img>` element, if neither the intrinsic width nor the intrinsic height of the source image exceeds the number of pixels allowed by the policy in the container (2 times larger than the container's width or height), the image will be rendered correctly; if the intrinsic width the source image exceeds the limit, a placeholder image will be rendered instead.


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

For an `<img>` element, if neither the intrinsic width or the intrinsic height of the source image exceeds the number of pixels allowed by the policy in the container (2 times larger than the container's width or height), the image will be rendered correctly; if the intrinsic height the source image exceeds the limit, a placeholder image will be rendered instead.
</br></br>


<a name="unoptimized-{lossy,lossless}-images">

### "unoptimized-lossy-images" policy and "unoptimized-lossless-images" policy

</a>

When optimizing images, the file size should be kept as small as possible. The larger the download size is, the longer it takes a page to load. Stripping metadata, picking a good image format, and using image compression, are all common ways to optimize an image's file size. `unoptimized-lossless-images` and `unoptimized-lossy-images` are policy controlled features that restricts images to a file size of no more than X times larger than the image resolution (width times height, pixels) on the web page.

When a document disallows the `unoptimized-lossless-images` policy or the `unoptimized-lossy-images` policy, the lossless or the lossy `<img>` elements whose file sizes are too large will be replaced with placeholder images.

**Note**: "unoptimized-lossy-images" policy and "unoptimized-lossless-images" policy do not apply on SVG images.

#### Specification
- The default allowlist for `unoptimized-lossless-images` and `unoptimized-lossy-images` is `*(inf)`. This means for pages of all origins, all `<img>` elements will be allowed and rendered correctly by default.

- The maximum file size allowrance is calculated as following:

   ```overhead allowance + byte-per-pixel ratio * image resolution``` 

   + The overhead allowance is tentatively set to 1KB (1024 bytes).
   + The byte-per-pixel ratio is specified by the user. 
        + The recommended byte-per-pixel ratio is **0.5** for lossy images ("unoptimized-lossy-images").
        + The recommended byte-per-pixel ratio is **1** for lossless images ("unoptimized-lossless-images").
 
- An "unoptimized-lossy-images" policy or an "unoptimized-lossless-images" policy can be specified via:

    **1. [HTTP `Feature-Policy`]( https://w3c.github.io/webappsec-feature-policy/#feature-policy-http-header-field) response header:**
    ```html
    Feature-Policy: unoptimized-lossy-images *(0);
    ```
    In this example, `unoptimized-lossy-images` is **disabled for all frames** including the main frame. Any `<img>` element of JPEG format whose file size is over 1KB will be replaced with placeholder images as the byte-per-pixel ratio allowed is 0.

    **2. [`allow` attribute in <iframe>](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#Attributes):**
    ```html
    <iframe src="https://example.com" allow="unoptimized-lossless-images 'self'(0.8) https://foo.com(1);">
    ```

    In this example, `unoptimized-lossless-images` is **disabled everywhere except on the origin of the main document and on `https://foo.com`**. On the origin of the main document, any non JPEG `<img>` element whose file size exeeds the maximum file size allowance (with pite-per-pixel ratio set to 0.8) will be replaced with a placeholder image. On 'https://foo.com', any non JPEG `<img>` element whose file size exeeds the maximum file size allowance (with pite-per-pixel ratio set to 1) will be replaced with a placeholder image. **`<img>` elements on any other origins whose file size exeeds 1KB will be replaced with placeholder images**.

- Feature policies combine in subframes, and the minimum value of the byte-per-pixel ratio will be applied, so if a frame, whose maximum byte-per-pixel ratio is set to 0.9 for unoptimized-lossy-images, embedded another, which the syntax:

    ```html
    Feature-Policy: unoptimized-lossy-images *(0.9);
    ```
    ```html
    <iframe allow="unoptimized-lossy-images *(1.2)"></iframe>
    ```
    then the child frame would be allowed to render images with maximum byte-per-pixel ratio set to **0.9**

    ```html
    Feature-Policy: unoptimized-lossy-images *(0.9);
    ```
    ```html
    <iframe allow="unoptimized-lossy-images *(0.2)"></iframe>
    ```
   then the child frame would be allowed to render images with maximum byte-per-pixel ratio set to **0.2**


#### Examples

<table>
  <tr align="center">
   <td width="400">Feature-Policy: unoptimized-lossy-images *(0.8); </td>
   <td width="400">Default behavior </td>
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

Any `<img>` element whose file size is within the allowance will be rendered correctly;

