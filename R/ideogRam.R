#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
ideogRam <- function(data, message, width = NULL, height = NULL, elementId = NULL) {

    if (is.null(elementId)) {
        elementId <- paste0('ideogRam_', tempfile() %>% basename()) 
        # avoid using - or ., which will make trouble for bind ID via: document.querySelector("body").innerHTML += container;
    }

    data$container = paste0('#', elementId)

    # forward options using x
    x = list(
             data = htmlwidgets:::toJSON(data),
             message = message
             )

    # create widget
    htmlwidgets::createWidget(
                              name = 'ideogRam',
                              x,
                              width = width,
                              height = height,
                              package = 'ideogRam',
                              elementId = elementId
                              )
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

ideogRamOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'ideogRam', width, height, package = 'ideogRam')
}

#' @rdname ideogRam-shiny
#' @export
renderIdeogRam <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ideogRamOutput, env, quoted = TRUE)
}
