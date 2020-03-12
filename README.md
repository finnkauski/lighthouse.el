<p align="left"><img align="left" src="meta/logo.png" width="240px"></p>

# Lighthouse.el

This is package wraps the functionality of the
[lighthouse](https://github.com/finnkauski/lighthouse) command line tool and
allows changing your lights from inside _doom-emacs_

<br>

It will evolve as a tool as more functionality is added to `lighthouse`.

<br>

> This package is developed for
> [doom-emacs](https://github.com/hlissner/doom-emacs) so tweaking and PRs are
> welcome to make it more generic.

## Demo

<img align="left" src="meta/lighthouse-demo.gif">

## Dependencies

Please follow the installation guide for
[lighthouse](https://github.com/finnkauski/lighthouse) and make sure it is in
your path.

## Usage

Enable `lighthouse mode` using

```
M-x lighthouse-mode
```

Then try `SPC l` to see the bindings.

## Buffer based tracking mode

Enable `lighthouse-tracking-mode` using

```
M-x lighthouse-tracking-mode
```

Currently supported modes:

- python
- org
- elisp
