# Policy Controlled Features

This document lists policy-controlled features being implemented in browsers. It
is not intended to be a complete list: browsers may choose to implement other
features not in this list. Nor is it intended to be normative: the definitions
of these features all belong in their respective specs.

| Feature name | Default allowlist | Brief Description |
| ------ | ------ | - |
|`accelerometer`|`self`|Controls access to accelerometer sensors on the device |
|`ambient-light-sensor`|`self`|Controls access to ambient light sensors on the device |
| `autoplay` | `self` | Controls access to autoplay through `play()` and `autoplay`. |
| `camera` | `self` | Controls access to video input devices.|
| `encrypted-media`| `self`|Controls whether `requestMediaKeySystemAccess()` is allowed.|
| `fullscreen`|`self`|Controls whether `requestFullscreen()` is allowed.|
|`geolocation`|`self`| Controls access to Geolocation interface. |
|`gyroscope`|`self`|Controls access to gyroscope sensors on the device |
|`magnetometer`|`self`|Controls access to magnetometer sensors on the device |
|`microphone`|`self` | Controls access to audio input devices. |
|`midi`|`self`|Controls access to `requestMIDIAccess()` method.|
|`payment`|`self`|Controls access to PaymentRequest interface.|
|`picture-in-picture`|`*`|Controls access to Picture in Picture.|
|`speaker`|`self`|Controls access to audio output devices.|
|`usb`|`self`|Controls access to USB devices.|
|`vr`|`self`|Controls access to VR displays.|

## Feature Definitions

### autoplay

The *autoplay* feature controls access to autoplay of media requested through the [HTMLMediaElement interface](http://w3c.github.io/html/semantics-embedded-content.html#htmlmediaelement).

If disabled in a document, then calls to [`play()`](http://w3c.github.io/html/semantics-embedded-content.html#dom-htmlmediaelement-play) without a user gesture will reject the promise with a `NotAllowedError` DOMException object as its parameter. The [`autoplay`](http://w3c.github.io/html/semantics-embedded-content.html#dom-htmlmediaelement-autoplay) attribute will be ignored.

* The **feature name** for *autoplay* is "`autoplay`"
* The **default allowlist** for *autoplay* is `'self'`.

### camera

The *camera* feature controls access to video input devices requested through the [NavigatorUserMedia interface](https://w3c.github.io/mediacapture-main/getusermedia.html#navigatorusermedia).

If disabled in a document, then calls to [`getUserMedia()`](https://w3c.github.io/mediacapture-main/getusermedia.html#dom-mediadevices-getusermedia()) MUST NOT grant access to video input devices in that document.

* The **feature name** for *camera* is "`camera`"
* The **default allowlist** for *camera* is `'self'`.

### encrypted-media

The *encrypted-media* feature controls whether [encrypted media extensions](https://w3c.github.io/encrypted-media/) are available.

If disabled in a document, the promise returned by [`requestMediaKeySystemAccess()`](https://w3c.github.io/encrypted-media/#navigator-extension-requestmediakeysystemaccess) must return a promise which rejects with a `SecurityError` DOMException object as its parameter.

* The **feature name** for *encrypted-media* is "`encrypted-media`"
* The **default allowlist** for *encrypted-media* is `'self'`.

### fullscreen

The *fullscreen* feature controls whether the [`requestFullscreen()`](https://fullscreen.spec.whatwg.org/#dom-element-requestfullscreen) method is allowed to request fullscreen.

If disabled in any document, the document will not be allowed to use fullscreen. If enabled, the document will be allowed to use fullscreen.

* The **feature name** for *fullscreen* is "`fullscreen`"
* The **default allowlist** for *fullscreen* is `'self'`.

### geolocation

The *geolocation* feature controls whether the current document is allowed to use the [Geolocation interface](https://dev.w3.org/geo/api/spec-source.html).

If disabled in any document, calls to both [`getCurrentPosition`](https://dev.w3.org/geo/api/spec-source.html#get-current-position) and [`watchPosition`](https://dev.w3.org/geo/api/spec-source.html#watch-position) must result in the error callback being invoked with `PERMISSION_DENIED`.

* The **feature name** for *geolocation* is "`geolocation`"
* The **default allowlist** for *geolocation* is `'self'`.

### microphone

The *microphone* feature controls access to audio input devices requested through the [NavigatorUserMedia interface](https://w3c.github.io/mediacapture-main/getusermedia.html#navigatorusermedia).

If disabled in a document, then calls to [`getUserMedia()`](https://w3c.github.io/mediacapture-main/getusermedia.html#dom-mediadevices-getusermedia()) MUST NOT grant access to audio input devices in that document.

* The **feature name** for *microphone* is "`microphone`"
* The **default allowlist** for *microphone* is `'self'`.

### midi

The *midi* feature controls whether the current document is allowed to use the [Web MIDI API](https://webaudio.github.io/web-midi-api/).

If disabled in a document, the promise returned by [`requestMIDIAccess()`](https://webaudio.github.io/web-midi-api/#dom-navigator-requestmidiaccess) must reject with a `DOMException` parameter.

* The **feature name** for *midi* is "`midi`"
* The **default allowlist** for *midi* is `'self'`.

### payment

The *payment* feature controls whether the current document is allowed to use the [PaymentRequest interface](https://w3c.github.io/browser-payment-api/).

If disabled in a document, then calls to the [`PaymentRequest` constuctor](https://w3c.github.io/browser-payment-api/#constructor) MUST throw a `SecurityError`.

* The **feature name** for *payment* is "`payment`"
* The **default allowlist** for *payment* is `'self'`.

### picture-in-picture

The *picture-in-picture* feature controls whether the current document is allowed to use [Picture In Picture](http://wicg.github.io/picture-in-picture).

If disabled in a document, then calls to [`requestPictureInPicture()`](https://wicg.github.io/picture-in-picture/#dom-htmlvideoelement-requestpictureinpicture) MUST throw a `SecurityError` and [`pictureInPictureEnabled`](https://wicg.github.io/picture-in-picture/#dom-document-pictureinpictureenabled) MUST return `false`.

* The **feature name** for *picture-in-picture* is "`picture-in-picture`"
* The **default allowlist** for *picture-in-picture* is `*`.

### sensor features

The sensor policy-controlled features are *ambient-light-sensor*, *accelerometer*,  *gyroscope*, and *magnetometer*.

A sensor feature controls access to a device sensor of a certain type requested either through an associated [Sensor](https://w3c.github.io/sensors/#the-sensor-interface)-based interface or through an event specified in the [DeviceOrientation Event Specification](https://www.w3.org/TR/orientation-event/).

If an interface (or an event) requires access to multiple sensors of different types than each of the corresponding sensor features MUST be allowed in order to use this interface. The table below shows which sensor features are required by the existing interfaces and events.

| Interface name | Required sensor policy-controlled features |
| ------ | ------ |
| [AmbientLightSensor interface](https://w3c.github.io/ambient-light/#ambient-light-sensor-interface) | *ambient-light-sensor* |
| [Accelerometer interface](https://w3c.github.io/accelerometer/#accelerometer-interface) | *accelerometer* |
| [LinearAccelerationSensor interface](https://w3c.github.io/accelerometer/#linearaccelerationsensor-interface) | *accelerometer* |
| [GravitySensor interface](https://w3c.github.io/accelerometer/#gravitysensor-interface) | *accelerometer* |
| [Gyroscope interface](https://w3c.github.io/gyroscope/#gyroscope-interface) | *gyroscope* |
| [AbsoluteOrientationSensor interface](https://w3c.github.io/orientation-sensor/#absoluteorientationsensor-interface) |*accelerometer*,  *gyroscope*, *magnetometer* |
| [RelativeOrientationSensor interface](https://w3c.github.io/orientation-sensor/#relativeorientationsensor-interface) | *accelerometer*, *gyroscope* |
| [deviceorientation Event](https://www.w3.org/TR/2016/CR-orientation-event-20160818/#deviceorientation) | *accelerometer*, *gyroscope* |
| [deviceorientationabsolute Event](https://www.w3.org/TR/2016/CR-orientation-event-20160818/#deviceorientationabsolute) | *accelerometer*, *gyroscope*, *magnetometer* |
| [devicemotion Event](https://www.w3.org/TR/2016/CR-orientation-event-20160818/#devicemotion)| *accelerometer*, *gyroscope* |
| [compassneedscalibration Event](https://www.w3.org/TR/2016/CR-orientation-event-20160818/#compassneedscalibration)| *magnetometer*|

If a required sensor feature is disabled in a document, then constructing of a [Sensor](https://w3c.github.io/sensors/#the-sensor-interface)-based interface object MUST throw a `SecurityError`. The events are not fired.

|Sensor feature| feature name | default allow list |
| ------ | ------ | ------ |
| *accelerometer* | "`accelerometer`" | `'self'` |
| *ambient-light-sensor* | "`ambient-light-sensor`" | `'self'` |
| *gyroscope* | "`gyroscope`" | `'self'` |
| *magnetometer* | "`magnetometer`" | `'self'` |

### speaker

The *speaker* feature controls access to audio output devices requested through the [NavigatorUserMedia interface](https://w3c.github.io/mediacapture-main/getusermedia.html#navigatorusermedia).

If disabled in a document, then calls to [`getUserMedia()`](https://w3c.github.io/mediacapture-main/getusermedia.html#dom-mediadevices-getusermedia()) MUST NOT grant access to audio output devices in that document.

* The **feature name** for *speaker* is "`speaker`"
* The **default allowlist** for *speaker* is `'self'`.

### usb

The *usb* feature controls whether the current document is allowed to use the [WebUSB API](https://wicg.github.io/webusb/).

If disabled in a document, then calls to the [`getDevices()`](https://wicg.github.io/webusb/#dom-usb-getdevices) should return a promise which rejects with a SecurityError DOMException.

* The **feature name** for *usb* is "`usb`"
* The **default allowlist** for *usb* is `'self'`.

### vr

The *vr* feature controls whether the current document is allowed to use the [WebVR API](https://immersive-web.github.io/webvr/spec/1.1/).

If disabled in a document, then calls to the [`getVRDisplays()`](https://immersive-web.github.io/webvr/spec/1.1/#navigator-getvrdisplays-attribute) should return a promise which rejects with a SecurityError DOMException.

* The **feature name** for *vr* is "`vr`"
* The **default allowlist** for *vr* is `'self'`.
