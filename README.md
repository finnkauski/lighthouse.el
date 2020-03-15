<p align="left"><img align="left" src="meta/logo.png" width="240px"></p>

# Lighthouse.el

This is package wraps the functionality of the
[lighthouse](https://github.com/finnkauski/lighthouse) command line tool and
allows changing your lights from inside _doom-emacs_. It also has these fun
minor modes:

- changing colors based on which buffer major mode is active
- changing colors based on how fast you are using Emacs

<br>

## Disclaimer

> This package is developed for
> [doom-emacs](https://github.com/hlissner/doom-emacs) so tweaking and PRs are
> welcome to make it more generic.
> The package is in active development.

## Demo

<p align="center"><img src="meta/lighthouse-demo.gif" height="400px"></p>

## Dependencies

You need the `lighthouse` binary in your path.

Please follow the installation guide for
[lighthouse](https://github.com/finnkauski/lighthouse).

# Usage

## lighthouse-mode

Basic hue lights control commands.

Enable `lighthouse-mode` in your `init.el` or using:

```
M-x lighthouse-mode
```

Then try `SPC l` to see the bindings.

## lightspeed-mode

Track how many commands (actions) your are doing in the span of 15 seconds and
alter the lights based on that. The more actions you perform the brighter the
lights are.

The brightness is bound between 0 - 254 in the `lighthouse` binary, hence the
calculation are done as `min((actions_per_15_s * 1.5), 254)` and the transitions
are set to take in 15 seconds (Note: I am not certain this setting is correctly
respected by the `Hue` as it seems to take less time).

Enable `lighthouse-speed-mode` in your `init.el` or using:

```
M-x lightspeed-mode
```

## lighthouse-tracking-mode

Tracks which buffers you are in and changes light color based on the buffer
type. Swapping from one active window to the next one will trigger the changes.
Opening a new buffer with a new major mode will also trigger color changes.

Enable `lighthouse-tracking-mode` in your `init.el` or using

```
M-x lighthouse-tracking-mode
```

### Currently supported modes and their colors:

- `ff00ff` - python
- `ff0000` - rustic (Rust)
- `ff00ff` - org-mode
- `f47883` - emacs-lisp-mode
- `ffd300` - web-mode (HTML)
- `ff0000` - css-mode

In order to use your own mode to color mapping, alter the `lighthouse-alist`
variable as this association list is what maps minor-modes to colors.
