library(data.table)
library(tidyverse)
library(glue)
library(here)
library(janitor)
options(tibble.width = Inf)
theme_set(theme_bw())

here::here()

library(usethis); ls("package:usethis")

usethis::use_github_action_check_standard()
usethis::use_tidy_github_actions()


install.packages("renv")
renv::init()


install.packages("styler")
styler::style_pkg()


install.packages("lintr")
lintr::lint_package()
usethis::use_github_action("lint")
usethis::use_tidy_github_actions()


if (FALSE) {    # spot check

    install.packages("prettycode")
    library(styler)
    ls("package:styler")
    ##  [1] "cache_activate"                 "cache_clear"
    ##  [3] "cache_deactivate"               "cache_info"
    ##  [5] "create_style_guide"             "default_style_guide_attributes"
    ##  [7] "specify_math_token_spacing"     "specify_reindention"
    ##  [9] "style_dir"                      "style_file"
    ## [11] "style_pkg"                      "style_text"
    ## [13] "tidyverse_math_token_spacing"   "tidyverse_reindention"
    ## [15] "tidyverse_style"

    style_text
    tidyverse_style

    styler::style_text(
                       '
                       foo <- function(posteriors, centrality = "median", dispersion = FALSE, ci = 0.89, ci_method = "hdi", test = c("p_direction", "rope"), rope_range = "default", rope_ci = 0.89, component = c("all", "conditional", "location"), parameters = NULL, ...) {}
                       '
    )

}    # End spot check



