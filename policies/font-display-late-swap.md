# Font Display Late Swap Policy

## Objective
Late loading of webfonts can cause layout instability and late text rendering. By  default, a fallback font gets rendered in place of the webfont which gets replaced when the font loads and causes elements to move depending on the differences between the fallback and the remote font. The objective is to prevent the page elements to move around because of this behavior.

## Solution
Introduce a new feature, namely, `font-display-late-swap` to control the value of `font-display` descriptor (more info on the `font-display` [here](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)). When the feature is disabled in a frame, all the `font-display` values will be restricted to `optional` for the frame (except for when explicitly set to `fallback`).

## Usage
A page can use the `font-display-late-swap` feature by specifying it in its HTTP header:

```
Feature policy: font-display-late-swap 'none'
```

which would disable the feature on the page. Alternatively, it can be set by modifying the `allow` attribute in the `iframe` tag. for example:

```
<iframe src="https://example.com" allow="font-display-late-swap 'none'"></iframe>
```

would disable the feature in the embedded frame.