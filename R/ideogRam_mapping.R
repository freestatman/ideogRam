
#' @export
show_mapping <- function(ideo, from, to, color = "green", opacity = 0.5) {
    ori.opts <- ideoraw(ideo)$options
    if (!is.null(ori.opts$onLoad)) {
        warning("onLoad option will be overided")
        # TODO: to combine the callbacks
    }

    stopifnot(is(from, "GRanges"), is(to, "GRanges"))
    stopifnot(length(from) == length(to))
    chr.from <- unique(seqnames(from))
    chr.to   <- unique(seqnames(to))
    stopifnot(length(chr.from) == 1)
    stopifnot(length(chr.to)   == 1)

    json.from <- jsonlite::toJSON(data.frame(
        start = start(from),
        stop  = end(from)
    ))
    json.to   <- jsonlite::toJSON(data.frame(
        start = start(to),
        stop  = end(to)
    ))

    jscallback <- JS(sprintf('function() {
        // FIXME: Just a hack
        var ideogram = window._myideogram;

        // ideogram is the shared variable of the widget
        // Find the chromosomes
        var chrs = ideogram.chromosomes;

        // Currently assume there is only one organism
        var organism = chrs[Object.keys(chrs)[0]];

        var chrfrom = organism["%s"];
        var chrto   = organism["%s"];

        var jsonfrom = %s;
        var jsonto   = %s;

        var drawregions = [];
        var each;

        for (var i = 0; i < jsonfrom.length; i++) {
            each = {
                "r1": {chr: chrfrom, start: jsonfrom[i].start, stop: jsonfrom[i].stop},
                "r2": {chr:   chrto, start:   jsonto[i].start, stop:   jsonto[i].stop},
                "color": "%s",
                "opacity": %s
            }
            drawregions.push(each);
        }
        console.log("Drawregions", drawregions);

	    ideogram.drawSynteny(drawregions);


    }', chr.from, chr.to, json.from, json.to, color, as.numeric(opacity)))

    ideoraw(ideo)$options$onLoad <- jscallback
    ideo
}


