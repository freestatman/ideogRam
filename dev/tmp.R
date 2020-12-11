
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
