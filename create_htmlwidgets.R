library(plyr)
library(tidyverse)
options(tibble.width = Inf)
theme_set(theme_bw())


#----------------------------------------------------------------------------
# build the htmlwidgets
#----------------------------------------------------------------------------
setwd('~/github/')
devtools::create("ideogRam")            # create package using devtools
setwd("ideogRam")                       # navigate to package dir

htmlwidgets::scaffoldWidget("ideogRam") # create widget scaffolding
setwd("~/github/ideogRam")              # navigate to package dir
devtools::install()                     # install the package so we can try it
devtools::build()                       # build R package


#----------------------------------------------------------------------------
# ideogRam examples
#   examples were replicated from https://github.com/eweitz/ideogram/tree/master/examples
#----------------------------------------------------------------------------
library(ideogRam)
library(htmlwidgets)

setwd("~/github/ideogRam")
devtools::install()        
library(ideogRam)


################
## example 1  ##
################
ideo_01_config <- list(organism='human',
                    orientation='horizontal',
                    annotations=list(list(name='xxx', 
                                          chr='2',
                                          start=34294,
                                          stop=125482
                                          ),
                                     list(name='BRCA1', 
                                          chr='17',
                                          start=43125400,
                                          stop=43125482))
                    )
htmlwidgets:::toJSON(ideo_01_config)
jsonlite::toJSON(ideo_01_config)

p <- ideogRam(data=ideo_01_config, message=NULL)
#htmlwidgets::saveWidget(p, '~/github/ideogRam/example/basic.html', selfcontained = TRUE)
htmlwidgets::saveWidget(p, '~/github/ideogRam/example/basic.html', selfcontained = FALSE)


################
## example 2  ##
################
annotationTracks = list(
                        list("id" = "pathogenicTrack", "displayName" = "Pathogenic", "color" = "#F00"),
                        list("id" = "uncertainSignificanceTrack", "displayName" = "Uncertain significance", "color" = "#CCC"),
                        list("id" = "benignTrack",  "displayName" = "Benign", "color" = "#8D4")
                        )

ideo_01_config <- list(organism='human',
                       orientation='horizontal',
                       chrWidth=8,
                       annotationsPath = "/annotations_tracks_files/Ideogram-0.9.0/data/annotations/1000_virtual_snvs.json",
                       annotationTracks = annotationTracks
                       )

p <- ideogRam(data=ideo_01_config, message=NULL)
htmlwidgets::saveWidget(p, '~/github/ideogRam/example/annotations_tracks.html', selfcontained = FALSE)

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

ideo_01_config <- list(organism='human',
                       annotationsPath =  "https://unpkg.com/ideogram@0.9.0/dist/data/annotations/10_virtual_cnvs.json",
                       annotationsLayout = "overlay" 
                       )

p <- ideogRam(data=ideo_01_config, message=NULL)
htmlwidgets::saveWidget(p, '~/github/ideogRam/example/annotations_tracks_urlPath.html', selfcontained = FALSE)



################
##   Shiny    ##
################
if (TRUE)  {     ## test in Shiny, Ideogram 0.9.0 start working for Shiny!

    library(shiny)
    library(ideogRam)

    ideo_01_config <- list(organism='human',
                        orientation='horizontal',
                        annotations=list(list(name='xxx', 
                                              chr='2',
                                              start=34294,
                                              stop=125482
                                              ),
                                         list(name='BRCA1', 
                                              chr='17',
                                              start=43125400,
                                              stop=43125482))
                        )

    #----------------------------------------------------------------------------
    # shiny example
    # not working. error msg:data/ folder is missing
    #----------------------------------------------------------------------------
    ui <- shinyUI( fluidPage(
                             ideogRamOutput( "jsed" )
                             )
    )

    server <- function(input,output){
        output$jsed <- renderIdeogRam({
            ideogRam(data=ideo_01_config, message=NULL, elementId='jsed')
        })
    }

    runApp( list( ui = ui, server = server ) )

}    # End 


if (TRUE)  {     # Shiny example 2: 2 ideogram graph

    library(shiny)
    library(ideogRam)


    #----------------------------------------------------------------------------
    # ideogRam shiny example works after v0.0.2
    #----------------------------------------------------------------------------
    server <- function(input, output){

        ideo_01_config <- list(organism='human',
                               orientation='horizontal',
                               annotations=list(list(name='xxx', 
                                                     chr='2',
                                                     start=34294,
                                                     stop=125482
                                                     ),
                                                list(name='BRCA1', 
                                                     chr='17',
                                                     start=43125400,
                                                     stop=43125482))
                               )

        ideo_02_config <- list(organism='human',
                               orientation='vertical',
                               annotations=list(list(name='xxx', 
                                                     chr='2',
                                                     start=1134294,
                                                     stop =1165482
                                                     ),
                                                list(name='BRCA1', 
                                                     chr='17',
                                                     start=43125400,
                                                     stop=43125482))
                               )


        output$ideo_01 <- renderIdeogRam({
            ideo_01_config$chromosome = as.character(input$chr)
            #observeEvent(input$chr, {
            ideogRam(data=ideo_01_config, message=NULL, elementId='ideo_01') # elementId has to be the same with output$ obj name
            #                                })
        })

        output$ideo_02 <- renderIdeogRam({
            ideogRam(data=ideo_02_config, message=NULL, elementId='ideo_02') # elementId has to be the same with output$ obj name
        })

    }

    ui <- shinyUI( fluidPage(
                             titlePanel("Hello IdeogRam!"),
                             sidebarPanel(width=2,
                                          numericInput("chr", "Chromosome:", 2, min = 1, max = 26)
                                          ),
                             mainPanel(
                                       column(5,
                                              ideogRamOutput( "ideo_01" )
                                              ),
                                       column(7,
                                              ideogRamOutput( "ideo_02" )
                                              )
                                       )
                             )
    )
    runApp( list( ui = ui, server = server ) )


}    # End 


