#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
ideogRam <- function(data, width = NULL, height = NULL, elementId = NULL) {

    # if (is.null(elementId)) {
    #     elementId <- paste0('ideogRam_', tempfile() %>% basename())
    #     # avoid using - or ., which will make trouble for bind ID via: document.querySelector("body").innerHTML += container;
    # }

    # data$container = paste0('#', elementId)

    # forward options using x
    x = list(data = htmlwidgets:::toJSON(data))

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
#' @examples
#' server <- function(input, output) {
#'     get_config <- reactive({
#'         list(
#'             organism = "human",
#'             orientation = "horizontal",
#'             chromosome = as.character(input$chr),   ## here is the issue....
#'             annotations = list(
#'                 list(
#'                     name = "xxx",
#'                     chr = "4",
#'                     start = 34294,
#'                     stop = 125482
#'                 ),
#'                 list(
#'                     name = "BRCA1",
#'                     chr = "17",
#'                     start = 43125400,
#'                     stop = 43125482
#'                 )
#'             ),
#'             # Note: for newer version of ideogram, it should be a character like "chr4:34294-1125482"
#'             brush = TRUE
#'         )
#'     })
#'     output$ideo_01 <- renderIdeogRam({
#'         ideo_01_config <- get_config()
#'         p <- ideogRam(data = ideo_01_config) # elementId has to be the same with output$ obj name
#'         p
#'     })
#'     output$region_desc <- renderText({
#'         rg <- input$ideo_01_brushrange
#'         paste0("From: ", rg$from, ";\n", "To: ", rg$to, ";\n", "Extent: ", rg$extent, ";\n")
#'     })
#' }
#'
#' ui <- shinyUI(fluidPage(
#'     titlePanel("Hello IdeogRam!"),
#'     sidebarPanel(
#'         width = 2,
#'         numericInput("chr", "Chromosome:", 4, min = 1, max = 26)
#'     ),
#'     mainPanel(
#'         ideogRamOutput("ideo_01"),
#'         verbatimTextOutput("region_desc")
#'     )
#' ))
#' runApp(list(ui = ui, server = server))

ideogRamOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'ideogRam', width, height, package = 'ideogRam')
}

#' @rdname ideogRam-shiny
#' @export
renderIdeogRam <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ideogRamOutput, env, quoted = TRUE)
}
