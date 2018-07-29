
#' @export
show_mapping <- function(ideo, from, to, color = "green", opacity = 0.5) {
    ori.opts <- ideoraw(ideo)

    stopifnot(is(from, "GRanges"), is(to, "GRanges"))
    stopifnot(length(from) == length(to))

    onLoad_DrawRegions <- data.frame(
        stringsAsFactors = FALSE,
        r1_chr = as.character(seqnames(from)),
        r1_start = start(from),
        r1_stop  = end(from),
        r2_chr = as.character(seqnames(to)),
        r2_start = start(to),
        r2_stop  = end(to),
        color = color,
        opacity = opacity
    )

    if (!is.null(ori.opts$onLoad_DrawRegions))
        onLoad_DrawRegions <- rbind(ori.opts$onLoad_DrawRegions, onLoad_DrawRegions)

    ideoraw(ideo)$onLoad_DrawRegions <- onLoad_DrawRegions

    ideo
}


