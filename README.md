# targets-parameterized-bookdown



Example repository for rendering a bookdown book, compiling parameterized
Rmarkdown documents, using the [targets](https://github.com/wlandau/targets)
package.


This example extends the
[targets-minimal](https://github.com/wlandau/targets-minimal) example. To mimic
a directory of input files, we split the example data into two chunks.

``` r
library(tidyverse)
data <- read_csv('data/raw_data.csv')

nrows <- 50

data1 <- head(data, n = nrows)
data2 <- tail(data, n = nrows)

write_csv(data1, 'data/split/data1.csv')
write_csv(data2, 'data/split/data2.csv')
```

To setup a target for our input files, we use `tar_files` from
[tarchetypes](https://github.com/wlandau/tarchetypes) (target: paths). Dynamic branching in
subsequent targets is mapped over these files (targets: raw_data, data, hist, fit).

Parameterized RMarkdown documents are generated by mapping over the fitted model
and histograms using a template document (`template/template.Rmd`) (target: report).

Finally, the output documents are merged into a book with bookdown. We use a
custom wrapper function `render_with_deps` to explicitly declare the book's
dependency on the output reports (target: book).




## Notes

* We need to change the extension of the parameterized github_document outputs 
(target: report) from `.md` to `.Rmd` because `bookdown` doesn't pick up `.md` files 
unless they are explicitly listed with the `rmd_files` argument in `_bookdown.yml`. 
See [here](https://github.com/rstudio/bookdown/issues/956).

* The `title` and `output_file` for rendered RMarkdown documents are set in this
example to the name of the branch  (target: report). If adapted for your own use, this could
alternatively be set to an id from the data, etc. 

* We can't use the `tar_render` function from `tarchetypes` because we need to 
call `bookdown::render_book` and not `rmarkdown::render` (target: book). 
Therefore, we need to track the `.Rmd` files in separate targets. 

* You *may* need to use `pandoc` >= [2.11.2](https://pandoc.org/releases.html#pandoc-2.11.2-2020-11-19) when generating the github_documents (target: report) so ATX style headings are used by default.
