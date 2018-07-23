
#' @export
show_mapping <- function(ideo, from, to, color = "green", opacity = 0.5) {
    ori.opts <- ideoraw(ideo)
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

    onLoad_DrawRegions <- data.frame(matrix(, nrow = length(from), ncol = 0))
    onLoad_DrawRegions$r1 <- data.frame(
        chr = chr.from, start = start(from), stop = end(from)
    )
    onLoad_DrawRegions$r2 <- data.frame(
        chr = chr.to, start = start(to), stop = end(to)
    )
    onLoad_DrawRegions$color <- color
    onLoad_DrawRegions$opacity <- opacity

    ideoraw(ideo)$onLoad_DrawRegions <- onLoad_DrawRegions

    ideo
}


