theme_set(theme_bw())
library(htmlwidgets)

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
ideo_config <- list(organism='human',
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
htmlwidgets:::toJSON(ideo_config)
jsonlite::toJSON(ideo_config)

p <- ideogRam(data=ideo_config, message=NULL)
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

ideo_config <- list(organism='human',
                    #dataDir='../data/bands/native',
                    orientation='horizontal',
                    chrWidth=8,
                    annotationsPath = "/annotations_tracks_files/Ideogram-0.9.0/data/annotations/1000_virtual_snvs.json",
                    annotationTracks = annotationTracks
                    )

p <- ideogRam(data=ideo_config, message=NULL)
htmlwidgets::saveWidget(p, '~/github/ideogRam/example/annotations_tracks.html', selfcontained = FALSE)


if (TRUE)  {     # ## test in Shiny, Ideogram 0.9.0 start working for Shiny!

    library(shiny)
    library(ideogRam)

    ideo_config <- list(organism='human',
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
            ideogRam(data=ideo_config, message=NULL)
        })
    }

    runApp( list( ui = ui, server = server ) )

}    # End 




