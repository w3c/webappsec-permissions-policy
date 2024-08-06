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
| `attribution-reporting` | [Attribution Reporting API][attribution-reporting] | [Chrome 115](https://chromestatus.com/feature/6412002824028160)  |
| `autoplay` | [HTML][html] | [Chrome 64](https://www.chromestatus.com/feature/5100524789563392) |
| `battery` | [Battery Status API][battery-status] | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=1007264)" in Chrome |
| `bluetooth` | [Web Bluetooth][bluetooth] | [Chrome 104](https://chromestatus.com/feature/6439287120723968) |
| `camera` | [Media Capture][media-capture] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `ch-ua` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-arch` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-bitness` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-full-version` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-full-version-list` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-mobile` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-model` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-platform` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-platform-version` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `ch-ua-wow64` | [User-Agent Client Hints][client-hints] | [Chrome 89](https://chromestatus.com/feature/5995832180473856) |
| `compute-pressure` | [Compute Pressure API][compute-pressure] | [Chrome 125](https://chromestatus.com/feature/5597608644968448) |
| `cross-origin-isolated` | [HTML][html] | Experimental in Chrome 85 |
| `direct-sockets` | [Direct Sockets API][direct-sockets] | | Status "[Started](https://chromestatus.com/feature/6398297361088512)" in Chrome |  
| `display-capture` | [Media Capture: Screen Share][media-capture-screen-share] | [Chrome 94](https://chromestatus.com/feature/5144822362931200) |
| `encrypted-media` | [Encrypted Media Extensions][encrypted-media] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `execution-while-not-rendered` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `execution-while-out-of-viewport` | [Page Lifecycle][page-lifecycle] | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `fullscreen` | [Fullscreen API][fullscreen] | [Chrome 62](https://www.chromestatus.com/feature/5094837900541952) |
| `geolocation` | [Geolocation API][geolocation] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `gyroscope` |[Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `hid` | [WebHID API][webhid] | [Chrome 89](https://chromestatus.com/feature/5172464636133376) |
| `identity-credentials-get` | [Federated Credential Management API][fedcm] | [Chrome 110](https://chromestatus.com/feature/5162418615877632) |
| `idle-detection` | [Idle Detection API][idle-detection] | [Chrome 94](https://chromestatus.com/feature/4590256452009984) |
| `keyboard-map` | [Keyboard API][keyboard] | [Chrome 97](https://www.chromestatus.com/feature/5657965899022336) |
| `magnetometer` |[Generic Sensor API][generic-sensor] | [Chrome 66](https://www.chromestatus.com/feature/5758486868656128) |
| `microphone` |[Media Capture][media-capture] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `midi` | [Web MIDI][web-midi] | [Chrome 64](https://www.chromestatus.com/feature/5023919287304192) |
| `navigation-override` | [CSS Spatial Navigation][navigation-override] |  |
| `payment` | [Payment Request API][payment-request] | Chrome 60 |
| `picture-in-picture` | [Picture-in-Picture][pip] | Shipped in Chrome |
| `publickey-credentials-get` | [Web Authentication API][publickey-credentials-get] | [Chrome 84](https://bugs.chromium.org/p/chromium/issues/detail?id=993007) |
| `screen-wake-lock` | [Wake Lock API][wake-lock] | [Chrome 84](https://www.chromestatus.com/feature/4636879949398016) |
| `serial` | [Web Serial API][web-serial] | [Chrome 89](https://chromestatus.com/feature/6577673212002304) |
| `sync-xhr` | [XMLHttpRequest][xhr] | [Chrome 65](https://www.chromestatus.com/feature/5154875084111872) |
| `usb` | [WebUSB][webusb] | Chrome 60 |
| `web-share` | [Web Share API][web-share] | Chrome 86 |
| `window-management`<sup>[5](#fn5)</sup> | [Window Management API][window-management] | [Chrome 111](https://chromestatus.com/feature/5146352391028736) |
| `xr-spatial-tracking`<sup>[2](#fn2)</sup> | [WebXR Device API][xr] | [Available as a Chrome Origin Trial](https://developers.chrome.com/origintrials/#/trials/active) |

## Proposed Features

These features have been proposed, but the definitions have not yet been
integrated into their respective specs.

| Feature name | Spec/PR link(s) | Browser Support |
| ------------ | --------------- | --------------- |
| `clipboard-read` | https://github.com/w3c/clipboard-apis/pull/120 | Chrome 86 |
| `clipboard-write` | https://github.com/w3c/clipboard-apis/pull/120 | Chrome 86 |
| `gamepad` | https://github.com/w3c/gamepad/pull/112 |  |
| `shared-autofill` | https://github.com/schwering/shared-autofill | |
| `speaker-selection` | https://github.com/w3c/mediacapture-output/pull/96 | |

## Experimental Features

These features generally have an explainer only, but may be available for
experimentation by web developers.

| Feature name | Link(s) | Browser Support |
| ------------ | ------- | --------------- |
| `all-screens-capture` | [Capture all screens API](https://screen-share.github.io/capture-all-screens/#feature-policy-integration) | In [Origin Trial](https://chromestatus.com/feature/6284029979525120) |
| `browsing-topics` | [Explainer](https://github.com/jkarlin/topics/) | Status "[Started](https://bugs.chromium.org/p/chromium/issues/detail?id=1294456)" in Chrome |
| `captured-surface-control` | [Captured Surface Control API][capture-surface-control]  | In [Origin Trial](https://chromestatus.com/feature/5092615678066688) |
| `conversion-measurement ` | [Explainer](https://github.com/WICG/conversion-measurement-api#publisher-controls-for-impression-declaration) | Experimental in Chrome<sup>[3](#fn3)</sup> |
| `digital-credentials-get` | [Explainer](https://wicg.github.io/digital-credentials/) | Behind a flag in Chrome<sup>[6](#fn6)</sup>
| `focus-without-user-activation` | [focus-without-user-activation.md](policies/focus-without-user-activation.md) | Status "[Open](https://bugs.chromium.org/p/chromium/issues/detail?id=965495)" in Chrome |
| `join-ad-interest-group` | [Protected Audience (formerly FLEDGE)][protected-audience] | Behind a flag in Chrome<sup>[4](#fn4)</sup> |
| `local-fonts` | [Local Font Access API][local-fonts] and [Explainer](https://github.com/WICG/local-font-access/blob/main/README.md) | [Experimental in Chrome](https://chromestatus.com/feature/6234451761692672) |
| `run-ad-auction` | [Protected Audience (formerly FLEDGE)][protected-audience] | Behind a flag in Chrome<sup>[4](#fn4)</sup> |
| `smart-card` | [Draft Spec](https://wicg.github.io/web-smart-card/#permissions-policy) and [Explainer](https://github.com/WICG/web-smart-card#readme) | [Prototyping in Chrome](https://chromestatus.com/feature/6411735804674048) |
| `sync-script` | | Behind a flag in Chrome<sup>[1](#fn1)</sup> |
| `trust-token-redemption` | [Explainer](https://github.com/WICG/trust-token-api) | In [Origin Trial](https://developers.chrome.com/origintrials/#/view_trial/2479231594867458049) in Chrome 84-87 |
| `unload` | [Explainer](https://github.com/fergald/docs/blob/master/explainers/permissions-policy-unload.md) | Status "[Started](https://crbug.com/1324111) in Chrome |
| `vertical-scroll` | [vertical\_scroll.md](policies/vertical_scroll.md) | Behind a flag in Chrome<sup>[1](#fn1)</sup> |

## Retired Features

These features were once standardized or proposed, but their specification
and/or implementations have been removed.

| Feature name | Spec link(s) | Browser Support |
| ------------ | ------------ | --------------- |
| `document-domain` | [HTML][html] | Formerly in Chrome, behind a flag |
| `window-placement` | [Window Management API][window-management] | Formerly in Chrome, changed to `window-management`<sup>[5](#fn5)</sup> |

## Notes

<a name="fn1">[1]</a>: To enable these, use the Chrome command line flag
`--enable-blink-features=ExperimentalProductivityFeatures`.

<a name="fn2">[2]</a>: Implemented in Chrome as `vr` prior to Chrome 79.

<a name="fn3">[3]</a>: To enable this, use the Chrome command line flag
`--enable-blink-features=ConversionMeasurement`.

<a name="fn4">[4]</a>: To enable this, use the Chrome command line flag
`--enable-features=AdInterestGroupAPI,InterestGroupStorage,Fledge`.

<a name="fn5">[5]</a>: Implemented in [Chrome 100](https://chromestatus.com/feature/5252960583942144) as `window-placement`;
changed in [Chrome 111](https://chromestatus.com/feature/5146352391028736) to `window-management`.

<a name="fn6">[6]</a>: To enable this, user the Chrome command line flag
`--enable-features=WebIdentityDigitalCredentials`.

[attribution-reporting]: https://wicg.github.io/attribution-reporting-api/#permission-policy-integration
[battery-status]: https://w3c.github.io/battery/#permissions-policy-integration
[bluetooth]: https://webbluetoothcg.github.io/web-bluetooth/#permissions-policy
[capture-surface-control]: https://screen-share.github.io/captured-surface-control
[compute-pressure]: https://www.w3.org/TR/compute-pressure/#policy-control
[client-hints]: https://wicg.github.io/ua-client-hints/
[direct-sockets]: https://wicg.github.io/direct-sockets/#permissions-policy
[encrypted-media]: https://w3c.github.io/encrypted-media/#permissions-policy-integration
[protected-audience]: https://wicg.github.io/turtledove/#permissions-policy-integration
[fedcm]: https://fedidcg.github.io/FedCM/#permissions-policy-integration
[fullscreen]: https://fullscreen.spec.whatwg.org/#permissions-policy-integration
[generic-sensor]: https://www.w3.org/TR/generic-sensor/#feature-policy
[geolocation]: https://w3c.github.io/geolocation-api/#permissions-policy
[html]: https://html.spec.whatwg.org/multipage/infrastructure.html#policy-controlled-features
[idle-detection]: https://wicg.github.io/idle-detection/#api-permissions-policy
[keyboard]: https://wicg.github.io/keyboard-map/#permissions-policy
[local-fonts]: https://wicg.github.io/local-font-access/#permissions-policy
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
[window-management]: https://w3c.github.io/window-management/#api-permission-policy-integration
[xhr]: https://xhr.spec.whatwg.org/#feature-policy-integration
[xr]: https://immersive-web.github.io/webxr/#permissions-policy
