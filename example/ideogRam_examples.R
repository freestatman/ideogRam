library(plyr)
library(tidyverse)
options(tibble.width = Inf)
theme_set(theme_bw())

if (FALSE) { # build, install the dev package
  
  # ----------------------------------------------------------------------------
  # build the htmlwidgets
  # ----------------------------------------------------------------------------
  #setwd("~/github/")
  #devtools::create("ideogRam") # create package using devtools
  #setwd("ideogRam") # navigate to package dir
  
  #htmlwidgets::scaffoldWidget("ideogRam") # create widget scaffolding
  
  setwd("~/github/ideogRam") # navigate to package dir
  devtools::install() # install the package so we can try it
  devtools::build() # build R package
  
  # ----------------------------------------------------------------------------
  # ideogRam examples
  #   examples were replicated from https://github.com/eweitz/ideogram/tree/master/examples
  # ----------------------------------------------------------------------------
  library(ideogRam)
  library(htmlwidgets)
  
  setwd("~/github/ideogRam")
  devtools::install()
}



library(ideogRam)

################
## example 1  ##
################
ideo_01_config <- list(
    organism = "human",
    orientation = "horizontal",
    annotations = list(
        list(
            name = "xxx",
            chr = "2",
            start = 34294,
            stop = 125482
        ),
        list(
            name = "BRCA1",
            chr = "17",
            start = 43125400,
            stop = 43125482
        )
    )
)
htmlwidgets:::toJSON(ideo_01_config)
jsonlite::toJSON(ideo_01_config)

p <- ideogRam(data = ideo_01_config, message = NULL)
p
# htmlwidgets::saveWidget(p, '~/github/ideogRam/example/basic.html', selfcontained = TRUE)
htmlwidgets::saveWidget(p, "~/github/ideogRam/example/basic.html", selfcontained = FALSE)


################
## example 2  ##
################
annotationTracks <- list(
    list("id" = "pathogenicTrack", "displayName" = "Pathogenic", "color" = "#F00"),
    list("id" = "uncertainSignificanceTrack", "displayName" = "Uncertain significance", "color" = "#CCC"),
    list("id" = "benignTrack", "displayName" = "Benign", "color" = "#8D4")
)

ideo_01_config <- list(
    organism = "human",
    orientation = "horizontal",
    chrWidth = 8,
    annotationsPath = "/annotations_tracks_files/Ideogram-0.9.0/data/annotations/1000_virtual_snvs.json",
    annotationTracks = annotationTracks
)

p <- ideogRam(data = ideo_01_config, message = NULL)
p
htmlwidgets::saveWidget(p, "~/github/ideogRam/example/annotations_tracks.html", selfcontained = FALSE)

################
## example 3  ##
################

# test native url input for annotationsPath: e.g. "https://unpkg.com/ideogram@0.9.0/dist/data/annotations/10_virtual_cnvs.json",
# https://github.com/eweitz/ideogram/issues/78
# var config = {
#       organism: "human",
#   annotationsPath: "https://unpkg.com/ideogram@0.9.0/dist/data/annotations/10_virtual_cnvs.json",
#     annotationsLayout: "overlay"
# };
# var ideogram = new Ideogram(config);

ideo_01_config <- list(
    organism = "human",
    annotationsPath = "https://unpkg.com/ideogram@0.9.0/dist/data/annotations/10_virtual_cnvs.json",
    annotationsLayout = "overlay"
)

p <- ideogRam(data = ideo_01_config, message = NULL)
p
htmlwidgets::saveWidget(p, "~/github/ideogRam/example/annotations_tracks_urlPath.html", selfcontained = FALSE)


################
## example 4  ##
################
ideo_01_config <- list(
                       organism = "banana",
                       orientation = "horizontal",
                       ploidy = 3,
                       chrMargin = 10,
                       ancestors = list(
                           "A" = "#dea673",
                           "B" = "#7396be"
                       ),
                       ploidyDesc = c(
                                    'AAB',
                                    'AAB',
                                    'BAB',
                                    'AAB',
                                    'AAB',
                                    'BBB',
                                    'AAB',
                                    'AAB',
                                    'AAB',
                                    'AAB',
                                    'AAB'
                                    ),
                       rangeSet = list(list(
                           chr = 1,
                           ploidy = c(0, 1, 0),
                           start = 17120000,
                           stop = 25120000,
                           color = c(0, '#7396be', 0)
                       ), list(
                           chr = 2,
                           ploidy = c(0, 1, 1),
                           start = 12120000,
                           stop = 15120000,
                           color = c(0, '#7396be', '#dea673')
                       ))
)


p <- ideogRam(data = ideo_01_config, message = NULL)
p

onRender()


################
## example 5  ##
## JS callback, brush example
################

# function writeSelectedRange() {
#   var r = ideogram.selectedRegion,
#   from = r.from.toLocaleString(), // Adds thousands-separator
#   to = r.to.toLocaleString(),
#   extent = r.extent.toLocaleString();
#   
#   document.getElementById("from").innerHTML = from;
#   document.getElementById("to").innerHTML = to;
#   document.getElementById("extent").innerHTML = extent;
# }

# var config = {
#   container: ".small-ideogram",
#   organism: "human",
#   chromosome: "19",
#   brush: true,
#   chrHeight: 900,
#   orientation: "horizontal",
#   onBrushMove: writeSelectedRange,
#   onLoad: writeSelectedRange
# };

################
##   Shiny    ##
################
if (TRUE) { ## Shiny Example 1, Ideogram 0.9.0 start working for Shiny!

    library(shiny)
    library(ideogRam)

    ideo_01_config <- list(
        organism = "human",
        orientation = "horizontal",
        annotations = list(
            list(
                name = "xxx",
                chr = "2",
                start = 34294,
                stop = 125482
            ),
            list(
                name = "BRCA1",
                chr = "17",
                start = 43125400,
                stop = 43125482
            )
        )
    )

    ui <- shinyUI(fluidPage(
        ideogRamOutput("jsed")
    ))

    server <- function(input, output) {
        output$jsed <- renderIdeogRam({
            ideogRam(data = ideo_01_config, message = NULL, elementId = "jsed")
        })
    }

    runApp(list(ui = ui, server = server))
} # End


if (TRUE) { # Shiny example 2: 2 ideogram graph

    library(shiny)
    library(ideogRam)

    # ----------------------------------------------------------------------------
    # ideogRam shiny example works after v0.0.2
    # ----------------------------------------------------------------------------
    server <- function(input, output) {
      
        get_config <- reactive({
        ideo_01_config <- list(
          organism = "human",
          orientation = "horizontal",
          chromosome = as.character(input$chr),
          annotations = list(
            list(
              name = "xxx",
              chr = "2",
              start = 34294,
              stop = 125482
            ),
            list(
              name = "BRCA1",
              chr = "17",
              start = 43125400,
              stop = 43125482
            )
          )
        )
        
      })
  
      
      ideo_02_config <- list(
        organism = "human",
        annotationsPath = "https://unpkg.com/ideogram@0.9.0/dist/data/annotations/10_virtual_cnvs.json",
        annotationsLayout = "overlay"
      )
      
      
      output$ideo_01 <- renderIdeogRam({
     
        ideo_01_config <- get_config()
        p <- ideogRam(data = ideo_01_config, message = NULL, elementId = "ideo_01") # elementId has to be the same with output$ obj name
        p$elementId <- 'test_id1'
        p
        
      })
      
      output$ideo_02 <- renderIdeogRam({
        p <- ideogRam(data = ideo_02_config, message = NULL, elementId = "ideo_02") # elementId has to be the same with output$ obj name
        p$elementId <- 'test_id2'
        p
        
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
          ideogRamOutput("ideo_02")
        )
    ))
    runApp(list(ui = ui, server = server))
} # End
