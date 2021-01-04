This repository provides a simple interactive Shiny app for plotting the RNA expression values 
reported in [*Lara-Astiaso et al., Science, 2014*](https://science.sciencemag.org/content/345/6199/943).

### Requirements

The following packages must be installed in R:

- shiny
- tidyverse
- ggplot2 >= 3.3

```r
install.packages(c('shiny', 'tidyverse', 'ggplot2'))
```

### Running

From an R session, run

```r
shiny::runGitHub("mfansler/shiny-mm-hspc-rna", ref="main")
```
