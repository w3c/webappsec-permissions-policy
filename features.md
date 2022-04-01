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
| `battery` | [Battery Status API][battery-status] | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=1007264)" in Chrome |
| `camera` | [Media Capture][media-capture] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `cross-origin-isolated` | [HTML][html] | Experimental in Chrome 85 |
| `display-capture` | [Media Capture: Screen Share][media-capture-screen-share] | |
| `document-domain` | [HTML][html] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `encrypted-media` | [Encrypted Media Extensions][encrypted-media] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `execution-while-not-rendered` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `execution-while-out-of-viewport` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `fullscreen` | [Fullscreen API][fullscreen] | [Chrome 62](https://www.chromestatus.com/feature/5094837900541952) |
| `geolocation` | [Geolocation API][geolocation] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `gyroscope` |[Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `hid` | [WebHID API][webhid] | [Chrome 89](https://chromestatus.com/feature/5172464636133376) |
| `idle-detection` | [Idle Detection API][idle-detection] | [Chrome 94](https://chromestatus.com/feature/4590256452009984) |
| `magnetometer` |[Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `microphone` |[Media Capture][media-capture] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `midi` | [Web MIDI][web-midi] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `navigation-override` | [CSS Spatial Navigation][navigation-override] |  |
| `payment` | [Payment Request API][payment-request] | Chrome 60 |
| `picture-in-picture` | [Picture-in-Picture][pip] | Shipped in Chrome |
| `publickey-credentials-get` | [Web Authentication API][publickey-credentials-get] | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=993007)" in Chrome |
| `screen-wake-lock` | [Wake Lock API][wake-lock] | [Chrome 84](https://www.chromestatus.com/feature/4636879949398016) |
| `serial` | [Web Serial API][web-serial] | [Chrome 89](https://chromestatus.com/feature/6577673212002304) |
| `sync-xhr` | [XMLHttpRequest][xhr] | [Chrome 65](https://www.chromestatus.com/feature/5154875084111872) |
| `usb` | [WebUSB][webusb] | Chrome 60 |
| `web-share` | [Web Share API][web-share] | Chrome 86 |
| `xr-spatial-tracking`<sup>[2](#fn2)</sup> | [WebXR Device API][xr] | [Available as a Chrome Origin Trial](https://developers.chrome.com/origintrials/#/trials/active) |

## Proposed Features

These features have been proposed, but the definitions have not yet been
integrated into their respective specs.

| Feature name | Spec/PR link(s) | Browser Support |
| ------------ | --------------- | --------------- |
| Client Hints<sup>[3](#fn3)</sup> | https://github.com/w3c/webappsec-feature-policy/issues/129 | |
| `clipboard-read` | https://github.com/w3c/clipboard-apis/pull/120 | Chrome 86 |
| `clipboard-write` | https://github.com/w3c/clipboard-apis/pull/120 | Chrome 86 |
| `gamepad` | https://github.com/w3c/gamepad/pull/112 |  |
| `speaker-selection` | https://github.com/w3c/mediacapture-output/pull/96 | |

## Experimental Features

These features generally have an explainer only, but may be available for
experimentation by web developers.

| Feature name | Link(s) | Browser Support |
| ------------ | ------- | --------------- |
| `browsing-topics` | [Explainer](https://github.com/jkarlin/topics/) | Status "[Started](https://bugs.chromium.org/p/chromium/issues/detail?id=1294456)" in Chrome |
| `conversion-measurement ` | [Explainer](https://github.com/WICG/conversion-measurement-api#publisher-controls-for-impression-declaration) | Experimental in Chrome<sup>[5](#fn5)</sup> |
| `focus-without-user-activation` | [focus-without-user-activation.md](policies/focus-without-user-activation.md) | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=965495)" in Chrome |
| `sync-script` | | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `trust-token-redemption` | [Explainer](https://github.com/WICG/trust-token-api) | In [Origin Trial](https://developers.chrome.com/origintrials/#/view_trial/2479231594867458049) in Chrome 84-87 |
| `vertical-scroll` | [vertical\_scroll.md](policies/vertical_scroll.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `window-placement` | [Explainer](https://github.com/webscreens/window-placement/blob/main/EXPLAINER.md) | In [Origin Trial](https://developer.chrome.com/origintrials/#/view_trial/-8087339030850568191) in Chrome 93-96 |


## Notes

<a name="fn1">[1]</a>: To enable these, use the Chrome command line flag
`--enable-blink-features=ExperimentalProductivityFeatures`.

<a name="fn2">[2]</a>: Implemented in Chrome as `vr` prior to Chrome 79.

<a name="fn3">[3]</a>: This represents a number of features. Individual feature
names will be added to this list as they are actually defined.

<a name="fn4">[4]</a>: To enable this, use the Chrome command line flag
`--enable-blink-features=Serial`.

<a name="fn5">[5]</a>: To enable this, use the Chrome command line flag
`--enable-blink-features=ConversionMeasurement`.

[battery-status]: https://w3c.github.io/battery/#permissions-policy-integration
[encrypted-media]: https://w3c.github.io/encrypted-media/#permissions-policy-integration
[fullscreen]: https://fullscreen.spec.whatwg.org/#permissions-policy-integration
[generic-sensor]: https://www.w3.org/TR/generic-sensor/#feature-policy
[geolocation]: https://w3c.github.io/geolocation-api/#permissions-policy
[html]: https://html.spec.whatwg.org/multipage/infrastructure.html#policy-controlled-features
[idle-detection]: https://wicg.github.io/idle-detection/#api-permissions-policy
[media-capture]: https://w3c.github.io/mediacapture-main/#permissions-policy-integration
[media-capture-screen-share]: https://w3c.github.io/mediacapture-screen-share/#permissions-policy-integration
[navigation-override]: https://drafts.csswg.org/css-nav-1/#policy-feature
[page-lifecycle]: https://wicg.github.io/page-lifecycle/#feature-policies
[payment-request]: https://www.w3.org/TR/payment-request/#permissions-policy
[pip]: https://wicg.github.io/picture-in-picture/#feature-policy
[publickey-credentials-get]: https://w3c.github.io/webauthn/#sctn-permissions-policy
[wake-lock]: https://w3c.github.io/screen-wake-lock/#policy-control
[web-midi]: https://webaudio.github.io/web-midi-api/#permissions-policy-integration
[web-serial]: https://wicg.github.io/serial/#permissions-policy
[web-share]: https://w3c.github.io/web-share/#permissions-policy
[webhid]: https://wicg.github.io/webhid/#permissions-policy
[webusb]: https://wicg.github.io/webusb/#permissions-policy
[xhr]: https://xhr.spec.whatwg.org/#feature-policy-integration
[xr]: https://immersive-web.github.io/webxr/#permissions-policy
