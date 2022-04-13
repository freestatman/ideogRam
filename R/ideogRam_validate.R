#' @include ideogRam.R
NULL

ideo_validate <- function(ideo) {
  validate_opts(ideo)
  invisible(ideo)
}

validate_opts <- function(ideo) {
  opts <- ideoraw(ideo)

  # It should be a list
  stopifnot(is.list(opts))
  # It must be named
  if (is.null(names(opts)) || any(names(opts) == "")) {
    stop("idoegram options must be named")
  }
  # Names should not be duplicated
  if (anyDuplicated(names(opts))) {
    stop("Names of ideogram options should not be duplicated")
  }
  # Check options
  for (i in seq_along(opts)) {
    local({
      name_opt <- names(opts)[[i]]
      if (!name_opt %in% known_opts) {
        warning(sprintf("Option %s is not part of api", name_opt))
      }
      if (name_opt %in% noneed) {
        warning("That option should not be supplied")
      }
    })
  }
  # TODO: check assembly, etc

  invisible(ideo)
}

known_opts <- c(
  "annotations",
  "annotationHeight",
  "annotationsColor",
  "annotationsLayout",
  "annotationsPath",
  "assembly",
  "barWidth",
  "brush",
  "chrHeight",
  "chrMargin",
  "chrWidth",
  "chromosomes",
  "container",
  "dataDir",
  "heatmaps",
  "onBrushMove",
  "onDrawAnnots",
  "onLoadAnnots",
  "onLoad",
  "onWillShowAnnotTooltip",
  "organism",
  "orientation",
  "ploidy",
  "resolution",
  "rotatable",
  "rows",
  "showBandLabels",
  "showChromosomeLabels",
  "showAnnotTooltip",
  "showFullyBanded",
  "showNonNuclearChromosomes",
  "onLoad_DrawRegions"
)

noneed <- c(
  "annotationsPath",
  "container",
  "dataDir"
)

# TODO: options which need processing
