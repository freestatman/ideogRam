  <!-- badges: start -->
  [![R build status](https://github.com/freestatman/ideogRam/workflows/R-CMD-che
ck/badge.svg)](https://github.com/freestatman/ideogRam/actions)
  <!-- badges: end -->

# ideogRam R htmlwidget package

ideogRam is an R htmlwidget wrapper package for Eric Weitz's ideogram.js [https://github.com/eweitz/ideogram].

This package is written for the [R project in GSoC 2018](https://summerofcode.withgoogle.com/projects/#6554027051974656).

## Install

devtools::install_github("freestatman/ideogRam")

## Example

See [example](https://github.com/freestatman/ideogRam/blob/master/example/ideogRam_examples.R) directory for some basic examples. more documentation is on the way...

Run the following R code to build the example website to "doc" directory:

```r
rmarkdown::render_site("example")
```

You can also see a shiny application example with

```r
example("ideogRam-shiny")
```

## Acknowledgement

Huge thanks to my mentors **Eric Weitz Jialin Ma** and **Freeman Wang** who helps me understand the nature of this project.
