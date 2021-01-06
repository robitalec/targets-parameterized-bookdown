
# targets-parameterized-bookdown

## Setup from targets-minimal

To mimic a directory of input files, we’ll split the example data into
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
