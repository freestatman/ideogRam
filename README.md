<!-- badges: start -->
[![R-CMD-check](https://github.com/freestatman/ideogRam/workflows/R-CMD-check/badge.svg)](https://github.com/freestatman/ideogRam/actions)
<!-- badges: end -->

# ideogRam R htmlwidget package

ideogRam is an R htmlwidget wrapper package for Eric Weitz's ideogram.js [https://github.com/eweitz/ideogram].

This package is written for the [R project in GSoC 2018](https://summerofcode.withgoogle.com/projects/#6554027051974656).

## Install

```r
devtools::install_github("freestatman/ideogRam")
```

## Example

See [vignettes](https://freestatman.github.io/ideogRam/articles/example1.html) for some basic examples.

ideogRam also works in shiny applications:
```r
example("renderIdeogRam")
example("ideogRamOutput")
```

## Acknowledgement

Huge thanks to my mentors **Eric Weitz, Jialin Ma** and **Freeman Wang** who helps me understand the nature of this project.
