# Fallback Font Policy

## Objective
Late loading of webfonts can cause layout instability (any sources?) and late text rendering. (no sources found yet to show it is one of the major causes of the problem). By default, the browser renders page layout but omits the text and waits for a webfont to download (and it uses a fallback font if the download timeouts). The objective is to ensure text remains visible during the webfont load.

## Solution
Introduce a new feature, namely, `fallback-font` to set the default value of `font-display` descriptor to `fallback` (more info on the `font-display` here: "https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display"). When the feature is enabled in a frame, the browser will render the frame with a fallback font and replaces it with the webfont as soon as it downloads (within the time limit).

## Usage
A page can use the `fallback-font` feature by specifying it in its HTTP header:

```
Feature policy: fallback-font '*'
```

which would enable the feature on the page. Alternatively, it can be set by modifying the `allow` attribute in the `iframe` tag. for example:

```
<iframe src="https://example.com" allow="fallback-font"></iframe>
```

would enable the feature on "https://example.com".