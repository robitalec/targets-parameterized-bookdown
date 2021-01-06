# targets-parameterized-bookdown

Example repository for rendering a bookdown book, compiling parameterized Rmarkdown documents, using the [targets](https://github.com/wlandau/targets) package.



## Setup from targets-minimal
This example extends the [targets-minimal](https://github.com/wlandau/targets-minimal) 
example. To mimic a directory of input files, we split the example data into
two chunks.

``` r
library(tidyverse)
data <- read_csv('data/raw_data.csv')

nrows <- 50

data1 <- head(data, n = nrows)
data2 <- tail(data, n = nrows)

write_csv(data1, 'data/split/data1.csv')
write_csv(data2, 'data/split/data2.csv')
```





## Notes

* We need to change the extension of the parameterized github_document outputs 
(target: report) from `.md` to `.Rmd` because `bookdown` doesn't pick up `.md` files 
unless they are explicitly listed with the `rmd_files` argument in `_bookdown.yml`. 
See [here](https://github.com/rstudio/bookdown/issues/956).

* The `title` and `output_file` for rendered RMarkdown documents are set in this
example to the name of the branch. If adapted for your own use, this could
alternatively be set to an id from the data, etc. 

* We can't use the `tar_render` function from `tarchetypes` because we need to 
call `bookdown::render_book` and not `rmarkdown::render`. Therefore, we need to track the `.Rmd` files in separate targets. 
