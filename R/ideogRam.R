
#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' @import GenomicRanges
NULL

#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
#' @example
#' data <- GRanges(c("2", "17"),
#'                 IRanges(c(34294, 43125400), c(125482, 43125482)), color = c("red", "green"))
#'
#' p <- ideogRam(organism = "human") %>%
#'     set_option(orientation = "horizontal") %>%
#'     add_track(data)
#' p
ideogRam <- function(..., width = NULL, height = NULL, elementId = NULL) {
  sizepolicy <- htmlwidgets::sizingPolicy(
    browser.fill = TRUE,
    knitr.figure = FALSE,
    knitr.defaultWidth = "100%",
    knitr.defaultHeight = "auto"
  )

  # create widget
  ans <- htmlwidgets::createWidget(
    name = "ideogRam",
    ## Initially it is NULL, but before rendering,
    ## x will be modified by the "compile_ideogram" function
    x = NULL,
    width = width,
    height = height,
    sizingPolicy = sizepolicy,
    package = "ideogRam",
    elementId = elementId,
    preRenderHook = compile_ideogram
  )

  # Store the options to attributes
  ideoraw(ans) <- list(...)

  ans
}

## The structure of ideogram class currently is like the following:
##   - attr("ideoraw")
##      - options: a list of options
##      - tracks: a list of GRanges

# Function that runs before rendering
compile_ideogram <- function(widget) {
  # Extract options
  ideoraw <- ideoraw(widget)

  ## Process annotations
  # From the documentation:
  #   Each annotation object has at least a chromosome name (chr), start coordinate (start),
  #   and stop coordinate (stop).
  #   Annotation objects can also have a name, color, shape, and track index.
  ideoraw$annotations <- local({
    annotations <- ideoraw[["annotations"]]
    for (i in seq_along(annotations)) {
      stopifnot(is(annotations[[i]], "GRanges"))
    }
    if (length(annotations)) {
      stopifnot(is.null(names(annotations)))
      annotations <- do.call(c, annotations)
      annotations <- as.data.frame(annotations) %>%
        dplyr::rename(chr = seqnames, stop = end) %>%
        dplyr::select(-width, -strand)
    }
    annotations
  })

  x <- list()
  # Pass processed options
  x$data <- ideoraw

  attr(x, "TOJSON_ARGS") <- list(
    auto_unbox = TRUE, dataframe = "rows"
  )

  widget$x <- x
  widget
}


ideoraw <- function(ideo) {
  attr(ideo, "ideoraw")
}

`ideoraw<-` <- function(ideo, value) {
  attr(ideo, "ideoraw") <- value
  ideo
}

#' @export
add_track <- function(ideo, ...) {
  stopifnot(inherits(ideo, "ideogRam"))

  dots <- list(...)
  stopifnot(all(sapply(dots, function(x) is(x, "GRanges"))))

  ideoraw(ideo)$annotations <- c(ideoraw(ideo)[["annotations"]], dots)
  ideo
}

#' @export
set_option <- function(ideo, ...) {
  stopifnot(inherits(ideo, "ideogRam"))

  dots <- list(...)
  if (is.null(names(dots)) || any(names(dots) == "")) {
    stop("Options must be named")
  }

  ideoraw(ideo)[names(dots)] <- dots

  # Validate the options
  ideo_validate(ideo)

  ideo
}



#' Shiny bindings for ideogRam
#'
#' Output and render functions for using ideogRam within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a ideogRam
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name ideogRam-shiny
#'
#' @export
#' @examples
#' library(shiny)
#' library(ideogRam)
#'
#' server <- function(input, output) {
#'   output$ideo_01 <- renderIdeogRam({
#'     chromosome <- input$chromosome
#'     organism <- input$organism
#'     orientation <- input$orientation
#'     if (orientation == "default") {
#'       orientation <- NULL
#'     }
#'
#'     barWidth <- as.numeric(input$barWidth)
#'     chrHeight <- as.numeric(input$chrHeight)
#'     chrMargin <- as.numeric(input$chrMargin)
#'     chrWidth <- as.numeric(input$chrWidth)
#'
#'     ploidy <- input$ploidy
#'     rows <- input$rows
#'     sex <- input$sex
#'
#'     rotatable <- as.logical(input$rotatable)
#'     showBandLabels <- as.logical(input$showBandLabels)
#'     showChromosomeLabels <- as.logical(input$showChromosomeLabels)
#'     showAnnotTooltip <- as.logical(input$showAnnotTooltip)
#'     showFullyBanded <- as.logical(input$showFullyBanded)
#'     showNonNuclearChromosomes <- as.logical(input$showNonNuclearChromosomes)
#'
#'     ideogRam(
#'       organism = organism, chromosome = chromosome, orientation = orientation,
#'       barWidth = barWidth, chrHeight = chrHeight, chrMargin = chrMargin, chrWidth = chrWidth,
#'       ploidy = ploidy, rows = rows, sex = sex,
#'       rotatable = rotatable,
#'       showBandLabels = showBandLabels,
#'       showChromosomeLabels = showChromosomeLabels,
#'       showAnnotTooltip = showAnnotTooltip,
#'       showFullyBanded = showFullyBanded,
#'       showNonNuclearChromosomes = showNonNuclearChromosomes
#'     )
#'   })
#' }
#'
#' ui <- shinyUI(fluidPage(
#'   titlePanel("Hello IdeogRam!"),
#'   sidebarPanel(
#'     width = 4,
#'     textInput("organism",
#'       label = "Organism", value = "human",
#'       placeholder = "Organism's name or organism's NCBI Taxonomy ID"
#'     ),
#'     textInput("chromosome",
#'       label = "Chromosome", value = "",
#'       placeholder = "Default showing all chromosomes"
#'     ),
#'     selectInput("orientation",
#'       label = "Orientation",
#'       choices = c("default", "horizontal", "vertical")
#'     ),
#'
#'     numericInput("barWidth", label = "barWidth", value = 3, min = 1, max = 10),
#'     numericInput("chrHeight", label = "chrHeight", value = 400, min = 10, max = 1000, step = 10),
#'     numericInput("chrMargin", label = "chrMargin", value = 10, min = 0, max = 100, step = 1),
#'     numericInput("chrWidth", label = "chrWidth", value = 10, min = 0, max = 100, step = 1),
#'
#'     numericInput("ploidy", label = "Ploidy", value = 1, min = 1, max = 8, step = 1),
#'     numericInput("rows", label = "rows", value = 1, min = 1, max = 5, step = 1),
#'     selectInput("sex", label = "sex", choices = c("male", "female")),
#'     checkboxInput("rotatable", label = "rotatable", value = TRUE),
#'     checkboxInput("showBandLabels", label = "showBandLabels", value = FALSE),
#'     checkboxInput("showChromosomeLabels", label = "showChromosomeLabels", value = TRUE),
#'     checkboxInput("showAnnotTooltip", label = "showAnnotTooltip", value = TRUE),
#'     checkboxInput("showFullyBanded", label = "showFullyBanded", value = TRUE),
#'     checkboxInput("showNonNuclearChromosomes",
#'       label = "showNonNuclearChromosomes",
#'       value = FALSE
#'     )
#'   ),
#'   mainPanel(
#'     ideogRamOutput("ideo_01")
#'   )
#' ))
#'
#' runApp(list(ui = ui, server = server))
ideogRamOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "ideogRam", width, height, package = "ideogRam")
}

#' @rdname ideogRam-shiny
#' @export
renderIdeogRam <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ideogRamOutput, env, quoted = TRUE)
}


## Util functions

debug_ideo <- function(ideo) {
  unclass(compile_ideogram(ideo))$x$data %>% jsonlite::prettify()
}


sample_10_virtual_cnvs <- function() {
  path <- system.file("htmlwidgets/lib/ideogram/data/annotations", "10_virtual_cnvs.json",
    package = "ideogRam", mustWork = TRUE
  )
  data <- jsonlite::fromJSON(path)
  annots <- data$annots

  seqnames <- rep(annots$chr, sapply(annots$annots, function(df) {
    if (is.list(df) && length(df) == 0) {
      return(0)
    } else {
      return(nrow(df))
    }
  }))
  seqnames
  start <- unlist(lapply(annots$annots, function(df) {
    if (is.list(df) && length(df) == 0) {
      return(numeric())
    } else {
      return(as.numeric(df[, 2]))
    }
  }))
  width <- unlist(lapply(annots$annots, function(df) {
    if (is.list(df) && length(df) == 0) {
      return(numeric())
    } else {
      return(as.numeric(df[, 3]))
    }
  }))
  name <- unlist(lapply(annots$annots, function(df) {
    if (is.list(df) && length(df) == 0) {
      return(character())
    } else {
      return(df[, 1])
    }
  }))
  color <- unlist(lapply(annots$annots, function(df) {
    if (is.list(df) && length(df) == 0) {
      return(character())
    } else {
      return(df[, 4])
    }
  }))
  ans <- data.frame(
    seqnames = seqnames, start = start, width = width,
    name = name, color = color, stringsAsFactors = FALSE
  )
  with(ans, GRanges(seqnames, IRanges(start = start, width = width),
    name = name, color = color
  ))
}

if (FALSE) {
  sample_10_virtual_cnvs()
}
