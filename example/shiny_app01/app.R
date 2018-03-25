library(shiny)
library(ideogRam)

server <- function(input, output) {
    get_config <- reactive({
        list(
            organism = "human",
            orientation = "horizontal",
            chromosome = as.character(input$chr),
            annotations = list(
                list(
                    name = "xxx",
                    chr = "4",
                    start = 34294,
                    stop = 125482
                ),
                list(
                    name = "BRCA1",
                    chr = "17",
                    start = 43125400,
                    stop = 43125482
                )
            ),
            # Note: for newer version of ideogram, it should be a character like "chr4:34294-1125482"
            brush = TRUE
        )
    })
    output$ideo_01 <- renderIdeogRam({
        ideo_01_config <- get_config()
        p <- ideogRam(data = ideo_01_config) # elementId has to be the same with output$ obj name
        p
    })
    output$region_desc <- renderText({
        rg <- input$ideo_01_brushrange
        paste0("From: ", rg$from, ";\n", "To: ", rg$to, ";\n", "Extent: ", rg$extent, ";\n")
    })
}

ui <- shinyUI(fluidPage(
    titlePanel("Hello IdeogRam!"),
    sidebarPanel(
        width = 2,
        numericInput("chr", "Chromosome:", 4, min = 1, max = 26)
    ),
    mainPanel(
        ideogRamOutput("ideo_01"),
        verbatimTextOutput("region_desc")
    )
))

runApp(list(ui = ui, server = server))



