library(targets)
library(tarchetypes)
source("R/functions.R")
options(tidyverse.quiet = TRUE)

tar_option_set(packages = c("tidyverse", "bookdown"))

list(
  tar_files(
    paths,
    dir('data/split', full.names = TRUE)
  ),
  tar_target(
    raw_data,
    read_csv(paths, col_types = cols()),
    pattern = map(paths)
  ),
  tar_target(
    data,
    raw_data %>%
      mutate(Ozone = replace_na(Ozone, mean(Ozone, na.rm = TRUE))),
    pattern = map(raw_data)
  ),
  tar_target(
    hist,
    create_plot(data),
    pattern = map(data)),
  tar_target(
    fit,
    lm(Ozone ~ Wind + Temp, data),
    pattern = map(data)),

  tar_file(template, 'template/template.Rmd'),

  tar_target(
    report,
    rmarkdown::render(
      template,
      params = list(
        histogram = hist,
        model = fit,
        title = as.character(tar_name())
      ),
      output_file = as.character(tar_name()),
      output_dir = 'chapters'
    ),
    pattern = map(hist, fit),
    format = 'file'
  )

)
