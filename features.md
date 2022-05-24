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
| `bluetooth` | [Web Bluetooth API][bluetooth] | [Chrome 104](https://chromestatus.com/feature/6439287120723968) |
| `camera` | [Media Capture][media-capture] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `ch-device-memory` | [Device Memory API][ch-device-memory] | [Chrome 61](https://chromestatus.com/feature/5741299856572416) |
| `ch-downlink` | [Network Information API][ch-downlink] | [Chrome 69](https://chromestatus.com/feature/5407907378102272) |
| `ch-dpr` | [Responsive Image Client Hints][ch-dpr] | [Chrome 46](https://chromestatus.com/feature/5504430086553600) |
| `ch-ect` | [Network Information API][ch-ect] | [Chrome 69](https://chromestatus.com/feature/5407907378102272) |
| `ch-rtt` | [Network Information API][ch-rtt] | [Chrome 69](https://chromestatus.com/feature/5407907378102272) |
| `ch-prefers-color-scheme` | [User Preference Media Features Client Hints Headers][ch-prefers-color-scheme] | [Chrome 93](https://chromestatus.com/feature/5642300464037888) |
| `ch-save-data` | [Save Data API][ch-save-data] | [Chrome 102](https://chromestatus.com/feature/5645928215085056) |
| `ch-ua` | [User-Agent Client Hints][ch-ua-*] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-arch` | [User-Agent Client Hints][ch-ua-*] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-bitness` | [User-Agent Client Hints][ch-ua-*] | [Chrome 93](https://chromestatus.com/feature/5733498725859328) |
| `ch-ua-full-version-list` | [User-Agent Client Hints][ch-ua-*] | [Chrome 98](https://caniuse.com/mdn-http_headers_sec-ch-ua-full-version-list) |
| `ch-ua-mobile` | [User-Agent Client Hints][ch-ua-*] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-model` | [User-Agent Client Hints][ch-ua-*] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-platform` | [User-Agent Client Hints][ch-ua-*] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `ch-ua-platform-version` | [User-Agent Client Hints][ch-ua-*] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-wow64` | [User-Agent Client Hints][ch-ua-*] | [Chrome 100](https://chromestatus.com/feature/5682026601512960) |
| `ch-viewport-width` | [User-Agent Client Hints][ch-viewport-width] | [Chrome 46](https://chromestatus.com/feature/5504430086553600) |
| `ch-width` | [User-Agent Client Hints][ch-width] | [Chrome 46](https://chromestatus.com/feature/5504430086553600) |
| `clipboard-read` | [Clipboard API and events][clipboard] | [Chrome 85](https://chromestatus.com/feature/57670752953958400) |
| `clipboard-write` | [Clipboard API and events][clipboard] | [Chrome 85](https://chromestatus.com/feature/57670752953958400) |
| `cross-origin-isolated` | [HTML][html] | [Chrome 87](https://chromestatus.com/feature/5690888397258752) |
| `display-capture` | [Media Capture: Screen Share][media-capture-screen-share] | [Chrome 94](https://chromestatus.com/feature/5144822362931200) |
| `document-domain` | [HTML][html] | [Chrome 77](https://chromestatus.com/feature/5341992867332096) |
| `encrypted-media` | [Encrypted Media Extensions][encrypted-media] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `execution-while-not-rendered` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `execution-while-out-of-viewport` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `focus-without-user-activation` | [HTML][focus-without-user-activation] | [Chrome 76](https://chromestatus.com/feature/5179186249465856) | 
| `fullscreen` | [Fullscreen API][fullscreen] | [Chrome 62](https://www.chromestatus.com/feature/5094837900541952) |
| `gamepad` | [Gamepad API][gamepad] | [Chrome 86](https://chromestatus.com/feature/5138714634223616) |
| `geolocation` | [Geolocation API][geolocation] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `gyroscope` | [Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `hid` | [WebHID API][webhid] | [Chrome 89](https://chromestatus.com/feature/5172464636133376) |
| `idle-detection` | [Idle Detection API][idle-detection] | [Chrome 94](https://chromestatus.com/feature/4590256452009984) |
| `keyboard-map` | [Keyboard Map API][keyboard-map] | [Chrome 97](https://chromestatus.com/feature/5657965899022336) |
| `local-fonts` | [Local Font Access API][local-fonts-access] |  [Chrome 103](https://chromestatus.com/feature/6234451761692672) |
| `magnetometer` | [Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `microphone` | [Media Capture][media-capture] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `midi` | [Web MIDI][web-midi] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `navigation-override` | [CSS Spatial Navigation][navigation-override] |  |
| `payment` | [Payment Request API][payment-request] | [Chrome 62](https://chromestatus.com/feature/5639348045217792)] |
| `picture-in-picture` | [Picture-in-Picture][pip] | Shipped in Chrome |
| `publickey-credentials-get` | [Web Authentication API][publickey-credentials-get] | [Chrome 70](https://chromestatus.com/feature/5669923372138496) |
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
| `ch-prefers-reduced-motion` | https://wicg.github.io/user-preference-media-features-headers/#policy-controlled-features |  |
| `ch-prefers-reduced-transparency` | https://wicg.github.io/user-preference-media-features-headers/#policy-controlled-features |  |
| `ch-prefers-contrast` | https://wicg.github.io/user-preference-media-features-headers/#policy-controlled-features |  |
| `ch-prefers-forced-colors` | https://wicg.github.io/user-preference-media-features-headers/#policy-controlled-features |  |
| Client Hints<sup>[3](#fn3)</sup> | https://github.com/w3c/webappsec-feature-policy/issues/129 | See above |
| `direct-sockets` | https://wicg.github.io/direct-sockets/#permissions-policy | |
| `speaker-selection` | https://github.com/w3c/mediacapture-output/pull/96 | [Behind a flag in Firefox 92](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy/speaker-selection) |

## Experimental Features

These features generally have an explainer only, but may be available for
experimentation by web developers.

| Feature name | Link(s) | Browser Support |
| ------------ | ------- | --------------- |
| `attribution-reporting` | [Attribution Reporting API][attribution-reporting] | In [Origin Trial](https://chromestatus.com/feature/6412002824028160) in Chrome 101-104 |
| `browsing-topics` | [Explainer](https://github.com/jkarlin/topics/) | In [Origin Trial](https://chromestatus.com/feature/5680923054964736) in Chrome 101-104 |
| `ch-partitioned-cookies` | [CHIPS (Cookies Having Independent Partitioned State)](https://github.com/WICG/CHIPS) | In [Origin Trial](https://chromestatus.com/feature/5179189105786880) in Chrome 100-102 |
| `ch-viewport-height` | [Responsive Image Client Hints](https://wicg.github.io/responsive-image-client-hints/#sec-ch-viewport-height) | In [Origin Trial](https://chromestatus.com/feature/5646861215989760) in Chrome 100-104 |
| `conversion-measurement ` | [Explainer](https://github.com/WICG/conversion-measurement-api#publisher-controls-for-impression-declaration) | Experimental in Chrome<sup>[5](#fn5)</sup> |
| `focus-without-user-activation` | [focus-without-user-activation.md](policies/focus-without-user-activation.md) | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=965495)" in Chrome |
| `join-ad-interest-group` | [First "Locally-Executed Decision over Groups" Experiment (FLEDGE)][join-ad-interest-group] |  In [Origin Trial](https://chromestatus.com/feature/5733583115255808) in Chrome 101-104 |
| `sync-script` | | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `trust-token-redemption` | [Explainer](https://github.com/WICG/trust-token-api) | In [Origin Trial](https://developers.chrome.com/origintrials/#/view_trial/2479231594867458049) in Chrome 84-87 |
| `vertical-scroll` | [vertical\_scroll.md](policies/vertical_scroll.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `window-placement` | [Explainer](https://github.com/webscreens/window-placement/blob/main/EXPLAINER.md) | In [Origin Trial](https://developer.chrome.com/origintrials/#/view_trial/-8087339030850568191) in Chrome 93-96 |

## Deprecated Features

These features were added to a browser and are still listed in the 
browsers source code, but have since been deprecated or replaced with a 
different feature name.

| Feature name | Spec link(s) | Browser Support | Description |
| ------------ | ------------ | --------------- | ----------- |
| `interest-cohort` | [Federated Learning of Cohorts][interest-cohort] | In [Origin Trial](https://chromestatus.com/feature/5710139774468096) in Chrome 89 to undefined | This proposal has been replaced by the [Topics API](https://github.com/jkarlin/topics/). |


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

[attribution-reporting]: https://wicg.github.io/conversion-measurement-api/#permission-policy-integration
[battery-status]: https://w3c.github.io/battery/#permissions-policy-integration
[bluetooth]: https://webbluetoothcg.github.io/web-bluetooth/#permissions-policy
[ch-device-memory]: https://www.w3.org/TR/device-memory/
[ch-downlink]: https://wicg.github.io/netinfo/#downlink-attribute
[ch-dpr]: https://wicg.github.io/responsive-image-client-hints/#sec-ch-dpr
[ch-ect]:  https://wicg.github.io/netinfo/#ect-request-header-field
[ch-rtt]: https://wicg.github.io/netinfo/#rtt-attribute
[ch-save-data]: https://wicg.github.io/savedata/
[ch-ua-*]: https://wicg.github.io/ua-client-hints/
[ch-prefers-color-scheme]: https://wicg.github.io/user-preference-media-features-headers/#policy-controlled-features
[ch-viewport-width]: https://wicg.github.io/responsive-image-client-hints/#sec-ch-viewport-width
[ch-width]: https://wicg.github.io/responsive-image-client-hints/#sec-ch-width
[clipboard]: https://w3c.github.io/clipboard-apis/#clipboard-permissions
[direct-sockets]: https://wicg.github.io/direct-sockets/#permissions-policy
[encrypted-media]: https://w3c.github.io/encrypted-media/#permissions-policy-integration
[focus-without-user-activation]: https://github.com/whatwg/html/pull/4585
[fullscreen]: https://fullscreen.spec.whatwg.org/#permissions-policy-integration
[gamepad]: https://www.w3.org/TR/gamepad/#permission-policy
[generic-sensor]: https://www.w3.org/TR/generic-sensor/#feature-policy
[geolocation]: https://w3c.github.io/geolocation-api/#permissions-policy
[html]: https://html.spec.whatwg.org/multipage/infrastructure.html#policy-controlled-features
[idle-detection]: https://wicg.github.io/idle-detection/#api-permissions-policy
[interest-cohort]: https://wicg.github.io/floc/#permissions-policy-integration
[join-ad-interest-group]: https://github.com/WICG/turtledove/blob/main/FLEDGE.md#11-joining-interest-groups
[local-fonts-access]: https://wicg.github.io/local-font-access/#permissions-policy
[keyboard-map]: https://wicg.github.io/keyboard-map/#permissions-policy
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
