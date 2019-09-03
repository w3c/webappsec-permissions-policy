# Policy Controlled Features

This document lists policy-controlled features being implemented in browsers. It
is broken into sections based on the standardization state of each feature. The
names used here should be consistent between browsers implementing a particular
feature, but there is no requirement that all browsers implement any single
feature.

The exact definition of the behaviour controlled by each feature belongs in the
spec which defines the feature. Those are linked where available.

## Standardized Features

These features have been declared in a published version of the respective
specification.

| Feature name | Spec link(s) | Browser Support |
| ------------ | ------------ | --------------- |
| `accelerometer` | [Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `ambient-light-sensor` | [Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `autoplay` | [HTML][html] | [Chrome 64](https://www.chromestatus.com/feature/5100524789563392) |
| `camera` | [Media Capture][media-capture] | Chrome 64 |
| `document-domain` | [HTML][html] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `fullscreen` | [Fullscreen API][fullscreen] | [Chrome 62](https://www.chromestatus.com/feature/5094837900541952) |
| `execution-while-not-rendered` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `execution-while-out-of-viewport` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `gyroscope` |[Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `magnetometer` |[Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `microphone` |[Media Capture][media-capture] | Chrome 64 |
| `midi` | [Web MIDI][web-midi] | Chrome 64 |
| `payment` | [Payment Request API][payment-request] | Chrome 60 |
| `picture-in-picture` | [Picture-in-Picture][pip] | Shipped in Chrome |
| `sync-xhr` | [XMLHttpRequest][xhr] | [Chrome 65](https://www.chromestatus.com/feature/5154875084111872) |
| `usb` | [WebUSB][webusb] | Chrome 60 |
| `wake-lock` | [Wake Lock API][wake-lock] | |
| `xr`<sup>[2](#fn2)</sup> | [WebXR Device API][xr] | [Available as a Chrome Origin Trial](https://developers.chrome.com/origintrials/#/trials/active) |

## Proposed Features

These features have been proposed, but the definitions have not yet been
integrated into their respective specs.

| Feature name | Spec/PR link(s) | Browser Support |
| ------------ | --------------- | --------------- |
| Client Hints<sup>[3](#fn3)</sup> | https://github.com/w3c/webappsec-feature-policy/issues/129 | |
| `encrypted-media` | https://github.com/w3c/encrypted-media/pull/432 | Chrome 64 |
| `geolocation` | https://github.com/w3c/permissions/pull/163 | Chrome 64 |
| `speaker` | https://github.com/w3c/mediacapture-main/issues/434 | Chrome 64 |
| `publickey-credentials` | [Web Authentication API][publickey-credentials] | |


## Experimental Features

These features generally have an explainer only, but may be available for
experimentation by web developers.

| Feature name | Link(s) | Browser Support |
| ------------ | ------- | --------------- |
| `document-write` | [document-write.md](policies/document-write.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `font-display-late-swap` | [font-display-late-swap.md](policies/font-display-late-swap.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `layout-animations` | [animations.md](policies/animations.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `loading-frame-default-eager` | [loading-frame-default-eager.md](policies/loading-frame-default-eager.md) | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=949683)" in Chrome<sup>[5](#fn5)</sup> |
| `loading-image-default-eager` | [loading-image-default-eager.md](policies/loading-image-default-eager.md) | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=949683)" in Chrome<sup>[5](#fn5)</sup> |
| `legacy-image-formats` | | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `oversized-images` | [optimized-images.md](policies/optimized-images.md) | In origin trials in M75</sup> |
| `sync-script` | | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `unoptimized-{lossy,lossless}-images` | [optimized-images.md](policies/optimized-images.md) | In origin trials in M75</sup> |
| `unsized-media` | [unsized-media.md](policies/unsized-media.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `vertical-scroll` | [vertical\_scroll.md](policies/vertical_scroll.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `serial` | | Experimental in Chrome<sup>[4](#fn4)</sup> |


## Notes

<a name="fn1">[1]</a>: To enable these, use the Chrome command line flag
`--enable-blink-features=ExperimentalProductivityFeatures`.

<a name="fn2">[2]</a>: Currently implemented in Chrome as `vr`.

<a name="fn3">[3]</a>: This represents a number of features. Individual feature
names will be added to this list as they are actually defined.

<a name="fn4">[4]</a>: To enable this, use the Chrome command line flag
`--enable-blink-features=Serial`.

<a name="fn5">[5]</a>: The earlier version of this feature ([`lazyload`](https://www.chromestatus.com/feature/5641405942726656)) is available behind a flag in Chrome<sup>[1](#fn1)</sup>.


[fullscreen]: https://fullscreen.spec.whatwg.org/#feature-policy-integration
[generic-sensor]: https://www.w3.org/TR/generic-sensor/#feature-policy
[html]: https://html.spec.whatwg.org/multipage/infrastructure.html#policy-controlled-features
[media-capture]: https://w3c.github.io/mediacapture-main/#feature-policy-integration
[page-lifecycle]: https://wicg.github.io/page-lifecycle/#feature-policies
[payment-request]: https://www.w3.org/TR/payment-request/#feature-policy
[pip]: https://wicg.github.io/picture-in-picture/#feature-policy
[publickey-credentials]: https://w3c.github.io/webauthn/#sctn-feature-policy
[wake-lock]: https://www.w3.org/TR/wake-lock/#dfn-wake-lock-feature
[web-midi]: https://webaudio.github.io/web-midi-api/#feature-policy-integration
[webusb]: https://wicg.github.io/webusb/#feature-policy
[xhr]: https://xhr.spec.whatwg.org/#feature-policy-integration
[xr]: https://immersive-web.github.io/webxr/#feature-policy
